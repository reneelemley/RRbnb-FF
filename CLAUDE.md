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
- **Hosts** (Ryan & Renée, listed in `public.hosts`) go to `/admin/` (or "Host sign-in"
  in the footer of `/stay/`), get an email sign-in link from Supabase, and can confirm,
  release or **change the dates of** any stay, add a stay directly as Reserved, block and
  move blocked dates, and add or turn off access codes — no code edits needed.
- **Island events** on `/stay/` (gold dots on calendar days + "On the islands" cards) come from the `EVDEF` / `EVS` lists in `stay/index.html` ("island events" block). Add or update dates there; `exp` = expected (hollow dot), no dates = "dates TBA" card only. Research notes: R&R Guides project `nodes/corridor/events-2027-2029.md`.
- Access today: one shared friends & family code, `FRIENDSOFR&R` (case-insensitive).
- New requests email `ryan@gusroberts.net` (cc `renee.lemley@mac.com`) through
  FormSubmit (formsubmit.co). The first ever submission sends a one-time activation
  email that must be clicked. Emails are sent from the browser after the request saves;
  a failed email never loses a booking.
- New requests also send the guest an automatic confirmation (FormSubmit `_autoresponse`).
- A GitHub Action (`.github/workflows/keep-supabase-awake.yml`) pings Supabase twice a week
  so the free project never pauses. GitHub turns off scheduled workflows after 60 days
  with no repo activity — if the calendar ever stops loading, re-enable it under Actions.
- Auth "Site URL" in Supabase is still `https://ryangusroberts.github.io/rrbnb-site/stay/`
  (Ryan's copy). Update it when the domain switches (see Hosting below).

## Stack & structure

- **Plain HTML/CSS/JS. No build step.** External scripts: supabase-js (CDN) on `/stay/`, and MapLibre GL + OpenFreeMap tiles for the home-page map. Each page is a self-contained `index.html` with
  its CSS and JS inlined. This mirrors how the owners' other site is built.
- Pages: `/` (home), `/stay/` (coded family page), `/book/` (public guest page).
- **Design system** lives in the `:root` CSS variables at the top of each page —
  change those tokens to recolour the whole site. Current look: white backgrounds with
  pale sea-mist bands, **deep sea blue** (`--stone`, #17587F, taken from the water in the photos) for the footer and dark buttons, navy for text,
  **Caribbean sea teal** (`--sea`) for primary actions, and brass **gold** only for the
  logo and small accents. No tan/linen/sand backgrounds: the owners asked for whites
  plus Caribbean colors. Keep it airy and restrained.
  Fonts: **Bodoni Moda** (Didone display serif, often italic gold) + **Jost** (Futura-like
  geometric sans for text, labels and spaced capitals). Chosen to match high-end resorts;
  don't revert to Fraunces/Inter. Every page sets `font-variation-settings:"opsz" 11` so
  Bodoni uses its sturdier text cut; without it the hairlines get too thin to read.
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

- **The live site is Renée's repo: `reneelemley/RRbnb-FF`** (GitHub Pages, currently
  https://reneelemley.github.io/RRbnb-FF/, soon **rrbnb.com**). Pushing to its `main`
  republishes in ~1–2 minutes. Ryan is a collaborator on it.
- `ryangusroberts/rrbnb-site` is Ryan's working copy (same history). Changes made there
  reach the live site only when synced: `cd rrbnb-site && git pull && git push
  https://github.com/reneelemley/RRbnb-FF.git main` (a normal fast-forward push, never force).
- **Private by design:** every page is `noindex, nofollow` and `robots.txt` disallows all.
  Link previews (Open Graph) use `assets/og-image.jpg` with absolute URLs.

### Switching the live site to rrbnb.com (domain is at GoDaddy)
Do these in order. Don't add `CNAME` before step 1 is done, or the github.io address
starts redirecting to a domain that doesn't answer yet.
1. **GoDaddy DNS** for rrbnb.com: four `A` records on `@` → 185.199.108.153,
   185.199.109.153, 185.199.110.153, 185.199.111.153; one `CNAME` record `www` →
   `reneelemley.github.io`. Remove GoDaddy's default parked/forwarding records for `@`/`www`.
2. **Repo:** rename `CNAME.example` → `CNAME` containing just `rrbnb.com`.
3. **Settings → Pages** (Renée only — collaborators can't see it): Custom domain
   `rrbnb.com`, save, wait for the DNS check, then tick **Enforce HTTPS**.
4. **Link previews:** in `index.html`, `stay/index.html`, `book/index.html` change the
   `og:url`/`og:image` URLs from `https://ryangusroberts.github.io/rrbnb-site/` to `https://rrbnb.com/`.
5. **Supabase** (project villa-rr → Authentication → URL Configuration): Site URL
   `https://rrbnb.com/stay/`; add Redirect URLs `https://rrbnb.com/stay/` and
   `https://reneelemley.github.io/RRbnb-FF/stay/`. Host sign-in links use the page's own
   address, which only works if it's on that list.
6. Check: open https://rrbnb.com, enter the family code on /stay/, and try a host sign-in.

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
