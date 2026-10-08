-- Villa R&R booking calendar: Supabase schema
-- Run once in the Supabase dashboard: SQL Editor -> New query -> paste -> Run.
-- Safe to re-run: everything is "if not exists" / "create or replace".
--
-- How it fits together
--   Guests never touch the tables directly. They call three functions:
--     check_code(code)          -> the code's label (e.g. "Mom") or null
--     calendar()                -> taken dates only (no names, no emails)
--     request_booking(...)      -> saves a request if the code is valid and the dates are free
--     cancel_booking(id, token) -> lets a guest cancel their own request from the same browser
--   Hosts (Ryan and Renee) sign in with an email link and get full access to
--   bookings, blocks and codes through row-level security.

create extension if not exists pgcrypto;
create extension if not exists btree_gist;

-- ---------- tables ----------
create table if not exists public.bookings (
  id           uuid primary key default gen_random_uuid(),
  check_in     date not null,
  check_out    date not null,
  name         text not null check (length(trim(name)) between 1 and 120),
  email        text not null check (email ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$'),
  party        int  not null check (party between 1 and 20),
  notes        text not null default '' check (length(notes) <= 2000),
  code_label   text,
  status       text not null default 'requested' check (status in ('requested','confirmed')),
  cancel_token uuid not null default gen_random_uuid(),
  created_at   timestamptz not null default now(),
  check (check_out > check_in),
  constraint bookings_no_overlap exclude using gist (daterange(check_in, check_out) with &&)
);

create table if not exists public.blocks (
  id         uuid primary key default gen_random_uuid(),
  check_in   date not null,
  check_out  date not null,
  reason     text not null default '',
  created_at timestamptz not null default now(),
  check (check_out > check_in)
);

create table if not exists public.access_codes (
  code       text primary key check (code = upper(trim(code)) and length(code) between 4 and 40),
  label      text not null check (length(trim(label)) between 1 and 80),
  active     boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.hosts (
  email text primary key
);
insert into public.hosts(email) values
  ('ryan@gusroberts.net'),
  ('renee.lemley@mac.com')
on conflict do nothing;

-- ---------- row-level security: hosts only ----------
alter table public.bookings     enable row level security;
alter table public.blocks       enable row level security;
alter table public.access_codes enable row level security;
alter table public.hosts        enable row level security;

create or replace function public.is_host() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (
    select 1 from public.hosts
    where lower(email) = lower(coalesce(auth.jwt() ->> 'email', ''))
  );
$$;

drop policy if exists hosts_all on public.bookings;
create policy hosts_all on public.bookings for all to authenticated
  using (public.is_host()) with check (public.is_host());

drop policy if exists hosts_all on public.blocks;
create policy hosts_all on public.blocks for all to authenticated
  using (public.is_host()) with check (public.is_host());

drop policy if exists hosts_all on public.access_codes;
create policy hosts_all on public.access_codes for all to authenticated
  using (public.is_host()) with check (public.is_host());

drop policy if exists hosts_read on public.hosts;
create policy hosts_read on public.hosts for select to authenticated
  using (public.is_host());

-- ---------- guest functions ----------
create or replace function public.check_code(p_code text) returns text
language sql stable security definer set search_path = public as $$
  select label from public.access_codes
  where code = upper(trim(p_code)) and active;
$$;

create or replace function public.calendar()
returns table (check_in date, check_out date, status text)
language sql stable security definer set search_path = public as $$
  select b.check_in, b.check_out, b.status from public.bookings b where b.check_out >= current_date
  union all
  select k.check_in, k.check_out, 'blocked' from public.blocks k where k.check_out >= current_date;
$$;

create or replace function public.request_booking(
  p_code text, p_check_in date, p_check_out date,
  p_name text, p_email text, p_party int, p_notes text default ''
) returns json
language plpgsql security definer set search_path = public as $$
declare
  v_label text;
  v_id    uuid;
  v_tok   uuid;
begin
  select label into v_label from public.access_codes
    where code = upper(trim(p_code)) and active;
  if v_label is null then
    raise exception 'invalid_code';
  end if;
  if p_check_in < current_date then
    raise exception 'past_dates';
  end if;
  if p_check_out > make_date(extract(year from current_date)::int + 3, 1, 1) then
    raise exception 'too_far';
  end if;
  if exists (select 1 from public.blocks
             where daterange(check_in, check_out) && daterange(p_check_in, p_check_out)) then
    raise exception 'dates_taken';
  end if;

  begin
    insert into public.bookings (check_in, check_out, name, email, party, notes, code_label)
    values (p_check_in, p_check_out, trim(p_name), trim(p_email), p_party, coalesce(trim(p_notes), ''), v_label)
    returning id, cancel_token into v_id, v_tok;
  exception when exclusion_violation then
    raise exception 'dates_taken';
  end;

  return json_build_object('id', v_id, 'cancel_token', v_tok, 'label', v_label);
end;
$$;

create or replace function public.cancel_booking(p_id uuid, p_token uuid) returns boolean
language plpgsql security definer set search_path = public as $$
begin
  delete from public.bookings where id = p_id and cancel_token = p_token;
  return found;
end;
$$;

-- Only the functions are open to the public; the tables stay closed.
revoke all on public.bookings, public.blocks, public.access_codes, public.hosts from anon;
revoke execute on function public.request_booking(text, date, date, text, text, int, text) from public;
revoke execute on function public.cancel_booking(uuid, uuid) from public;
revoke execute on function public.check_code(text) from public;
revoke execute on function public.calendar() from public;
grant execute on function public.check_code(text) to anon, authenticated;
grant execute on function public.calendar() to anon, authenticated;
grant execute on function public.request_booking(text, date, date, text, text, int, text) to anon, authenticated;
grant execute on function public.cancel_booking(uuid, uuid) to anon, authenticated;
grant execute on function public.is_host() to authenticated;
