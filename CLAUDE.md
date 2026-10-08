# Villa R&R — website

A small, high-end **boutique villa site** (Villa R&R, in Sint Maarten). Its whole job is to look beautiful and let
the right people **request a week to stay**. Bookings are arranged **directly by email
and settled in cash in person** — there is no payment system, no login, no database,
and (deliberately) none of that complexity. Keep it simple.

> **If you are Claude reading this: this file is your brief. Read it fully before
> making changes. The person you're helping (likely Renee) is not a developer — explain
> what you're doing in plain language, keep the code clean and self-contained, and don't
> add tools, frameworks, or backends unless she explicitly asks.**

## What this site is for

Two audiences, one villa, one shared availability calendar:

1. **Friends & family** (`/stay/`) — free stays. Enter a **personal access code**
   (checked on the server) → live calendar → pick dates → send a request with
   name and email. Live now.
2. **Friends of friends** (`/book/`) — **coming soon**. The page and the "Book as a
   guest" card show a Coming Soon state; don't re-enable without the owners asking.

## The booking system (Supabase)

- Backend: Supabase project `villa-rr` (org "R&R"). Schema, security rules and
  functions live in `supabase/schema.sql` — re-run it in the SQL Editor after edits.
- `stay/index.html` holds the public project URL and **publishable** key. These are
  meant to be public; row-level security keeps guest names/emails private.
- Guests never read tables. They call `check_code`, `calendar` (dates + status only),
  `request_booking` (validates code, dates, overlaps) and `cancel_booking` (own request,
  same browser, via a cancel token).
- **Hosts** (Ryan & Renée, listed in `public.hosts`) click "Hosts" in the footer of
  `/stay/`, get an email sign-in link, and can confirm/release requests, block dates,
  and add or turn off access codes — no code edits needed.
- New requests email `ryan@gusroberts.net` (cc `renee.lemley@mac.com`) through
  FormSubmit (formsubmit.co). The first ever submission sends a one-time activation
  email that must be clicked. Emails are sent from the browser after the request saves;
  a failed email never loses a booking.
- Auth "Site URL" in Supabase is `https://ryangusroberts.github.io/rrbnb-site/stay/`.
  If the site moves to a custom domain, update it there and add the new URL.

## Stack & structure

- **Plain HTML/CSS/JS. No build step.** The only external script is supabase-js (CDN) on `/stay/`. Each page is a self-contained `index.html` with
  its CSS and JS inlined. This mirrors how the owners' other site is built.
- Pages: `/` (home), `/stay/` (coded family page), `/book/` (public guest page).
- **Design system** lives in the `:root` CSS variables at the top of each page —
  change those tokens to recolour the whole site. Current look: white backgrounds with
  pale sea-mist bands, **deep sea blue** (`--stone`, #17587F, taken from the water in the photos) for the footer and dark buttons, navy for text,
  **Caribbean sea teal** (`--sea`) for primary actions, and brass **gold** only for the
  logo and small accents. No tan/linen/sand backgrounds: the owners asked for whites
  plus Caribbean colors. Keep it airy and restrained.
  Fonts: **Fraunces** (display serif, often italic) + **Inter** (UI).
- Shared building blocks reused across pages: sticky `.nav`, `.btn` variants
  (`.btn-solid` stone, `.btn-gold`, `.btn-line`), `.eyebrow` small-caps with gold
  hairlines, `.rev` reveal-on-scroll, `.ph` image placeholders, footer.

## Brand & logo

- Name: **Villa R&R**. The mark is a gold **R&R** monogram (with the Sint Maarten
  island outline in the final artwork). Chosen style: **Version 3** — the interlocked,
  jewelry-inspired ampersand.
- The logo is a **drop-in file at `/assets/logo.svg`**, used in the nav, hero, and footer.
  What ships is a real vector R&R monogram — copperplate letterforms in gold with the
  Sint Maarten island outline framing them (a faithful take on the chosen Version 3).
  To swap in the owner's exact artwork: replace `assets/logo.svg` with their file (keep
  the name), or if it's a PNG, save it as `assets/logo.png` and update the three
  `<img src="assets/logo.svg">` references (nav, hero `.brandmark`, footer). The favicon
  is `assets/favicon.svg` (the R&R mark on its own).

## Hosting & publishing

- Hosted on **GitHub Pages**. Pushing to `main` republishes in ~1–2 minutes.
- Custom domain: rename `CNAME.example` → `CNAME`, put the real domain inside, and set
  it in the repo's **Settings → Pages**. No custom domain yet? Leave `CNAME.example`
  as-is (it does nothing) and the site lives at the `github.io` URL.

## Conventions & guardrails

- Keep every page **self-contained** (inline CSS/JS) and reuse the nav + footer markup.
- **Placeholders are marked** with `EDIT ME`, `data-label="PHOTO — ..."`, and
  `PASTE_..._HERE`. Real villa photos go in `/assets/photos/`; swap the `.ph` blocks for
  `<img>` tags pointing at them.
- Don't introduce npm, React, Tailwind, a CMS, or a server unless asked. This is a
  static site on purpose.
- The private `/stay/` page carries `<meta name="robots" content="noindex">` — keep it.

## Good first things to help Renee with

- Swap the placeholder logo at `/assets/logo.svg` for the real Version 3 export.
- Replace the location, bedroom counts, and copy with the real details.
- Drop the real photos into `/assets/photos/` and swap the gallery placeholders.
- Add family members' access codes from the host view on `/stay/` (not in code).
