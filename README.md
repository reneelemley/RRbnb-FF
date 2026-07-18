# Villa R&R — start here 🌴

Hi Renee! This folder is a complete, good-looking starting point for the villa website.
It already has a home page, a private **friends & family** page (with personal access
codes), and a shareable **guest booking** page — all styled in a clean white / linen /
sand look with the gold **R&R** monogram.

**You will not write any code.** You make this yours by *chatting with Claude*. This guide
gets you set up and gives you the exact first message to send. Take it slow; each step is
short.

---

## The big picture (30 seconds)

- The site is just files that live on **GitHub** (a free place to store a website).
- **GitHub Pages** turns those files into a real, live website for free.
- **Claude** edits the files for you when you ask — in plain English — and publishes them.
- "Booking" is simply an **email to the owners**. No payments, no accounts, nothing to
  maintain but a calendar. On purpose.

So the flow is: get your own copy on GitHub → turn on the website → connect Claude → then
just talk to Claude to make it yours.

---

## Step 1 — Get your own copy (5 min)

1. Make a free account at **github.com** if you don't have one.
2. Go to the template repository link Ryan sends you. Click the green **“Use this
   template”** button → **“Create a new repository.”**
3. Give it a name — for example `villa` — and click **Create repository**. 🎉 You now own
   your own private copy of the whole site.

## Step 2 — Turn the website on (2 min)

1. In your new repository, click **Settings** (top menu) → **Pages** (left menu).
2. Under **Source**, choose **Deploy from a branch**.
3. Set **Branch** to **`main`** and the folder to **`/ (root)`**, then click **Save**.
4. Wait ~2 minutes, refresh, and GitHub shows a link like
   `https://yourname.github.io/villa/`. That's your live site. Open it — you'll see the
   villa home page with placeholder photos. 👍

## Step 3 — Connect Claude (5 min)

In the Claude desktop app:

1. Start a new Cowork project and **connect your new GitHub repository** to it (so Claude
   can read the site and publish your changes).
2. **Connect Chrome** too (so Claude can open your live site and see its own edits).

If a step is unclear, just ask Claude in the chat — e.g. “help me connect my GitHub repo”
— and it'll walk you through it.

## Step 4 — Your first message to Claude (copy/paste this)

> I'm building the website for our villa, **Villa R&R**, in Sint Maarten, from this
> template. Please read `CLAUDE.md` first — it explains how the site works and how it's
> meant to stay simple. Then help me make it real, one step at a time. Start by asking me
> for: the villa's real details (location, bedrooms, how many it sleeps), our contact
> email, and a short description. Update the home page with what I give you, show me the
> result, and we'll go from there. Keep it a simple static site — no payment systems or
> logins.

From there, just ask for what you want in plain English.

---

## Things you'll likely want to ask Claude for

- “Here are our villa photos — put them in the gallery and the hero.” *(Drag the photos
  right into the chat.)*
- “Here's our real logo file — use it in place of the placeholder.” *(Drag it in.)*
- “Set our contact email to `ourvilla@gmail.com` everywhere.”
- “Set up our Google Calendar so people can see which weeks are open.” *(see below)*
- “Add personal access codes for my mom, the Davis family, and my sister.”
- “Write warmer descriptions for the villa and the location.”
- “Change the sand tone to be a little lighter / warmer.”
- “Publish it.” *(Claude saves to GitHub and your live site updates in ~2 minutes.)*

## The one thing worth doing early: the calendar

The open-weeks calendar is a **free Google Calendar** you make just for the villa:

1. Create a new Google Calendar (e.g. “Villa R&R availability”).
2. Add an all-day event on any week that's **booked/blocked**.
3. Make the calendar **public** (Google Calendar → Settings → “Make available to public”).
4. Tell Claude: *“connect our villa Google Calendar to the stay and booking pages,”* and
   it'll wire it in.

After that, you open and close weeks by editing the calendar — never the website. The same
calendar shows on both the family page and the guest page.

## How the two booking pages work

- **Family & friends** (`/stay/`): visitors type a **personal code** to see the calendar
  and email you their dates. The codes are in the site (Claude manages them for you) — they
  keep the page private-feeling. They're a soft gate, not a bank vault: the real control is
  that *you* confirm every stay by email.
- **Book a guest** (`/book/`): a link you can share with friends-of-friends. No code, shows
  a small nightly rate, same email-to-book flow.

---

## Where things are (just so you know)

```
index.html          the home page
stay/index.html     friends & family page (personal codes)
book/index.html     public guest booking page
assets/logo.svg     the R&R logo (swap for your real artwork anytime)
assets/photos/      drop your villa photos here
CLAUDE.md           the brief Claude reads — how the site is meant to work
```

Anything marked **`EDIT ME`**, **`Photo — …`**, or **`PASTE …HERE`** is a placeholder
waiting for the real thing. You don't have to hunt for them — just tell Claude what you
want and it'll find them.

You've got this. Enjoy making it yours. 🏡
