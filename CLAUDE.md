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

1. **Friends & family** (`/stay/`) — free stays. Reach the page with a **personal
   access code**. Enter code → see open weeks → email to request dates.
2. **Friends of friends** (`/book/`) — a shareable public page. No code. Same open
   weeks, plus a **small nightly rate** to cover cleaning/expenses. Email to request.

The physical villa is one place, so **availability is the same for both** — if a week
is booked, it's booked for everyone. Both pages should show the *same* calendar.

## The booking model (important — don't over-build it)

- **No booking engine, no online payments, no Stripe, no accounts.** Every stay is
  confirmed by a human (the owners) over email, then paid in cash on arrival.
- "Booking" on the site = a **pre-filled `mailto:` link**. The visitor picks a week from
  the calendar, clicks the button, and their email app opens with the details ready.
- The **access codes are a soft gate, not security.** They live in plain JavaScript in
  `/stay/index.html` (the `CODES` object) and anyone technical could read them. That's
  fine: the real gatekeeper is the owner, because nothing is confirmed until they reply.
  The code just makes the page feel private and personal, one code per person.
- If asked to make codes "more secure," explain the honest tradeoff: truly private
  availability needs a backend (a serverless function + a hidden calendar), which adds
  real complexity. Only go there if she clearly wants it.

## The availability calendar

The simplest reliable approach is a **public Google Calendar** made just for the villa:
mark booked weeks as all-day events, make the calendar public (read-only), and paste its
**embed URL** into the `<iframe>` in both `/stay/index.html` and `/book/index.html`
(look for `PASTE_GOOGLE_CALENDAR_EMBED_URL_HERE`). Until that's done, a friendly
placeholder shows instead. The owner blocks/opens weeks by editing the calendar — no
code changes needed after it's wired once.

## Stack & structure

- **Plain HTML/CSS/JS. No build step.** Each page is a self-contained `index.html` with
  its CSS and JS inlined. This mirrors how the owners' other site is built.
- Pages: `/` (home), `/stay/` (coded family page), `/book/` (public guest page).
- **Design system** lives in the `:root` CSS variables at the top of each page —
  change those tokens to recolour the whole site. Current look: *quiet-luxury boutique*
  — warm white / linen / sand, generous whitespace, hairline **gold** accents used
  sparingly, and a single soft espresso (`--stone`) anchor at the footer. Keep it airy
  and restrained; the gold should feel like jewelry, not paint.
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
- Wire the Google Calendar into both pages.
- Set the real contact email everywhere (`hello@example.com` → the owners' address).
- Add each family member's personal code to the `CODES` list in `/stay/index.html`.
