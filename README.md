# Habit Squad 🔥

A shared daily habit tracker for up to 10 friends. Pick your name, check off your habits, add photos, and see who's winning.

- **Site:** a single `index.html`, hosted free on GitHub Pages
- **Data and photos:** Supabase (free tier)
- **No passwords:** you pick your name once per device

---

## 1. Try it first (optional, 1 minute)

Open `index.html` in your browser. With no Supabase keys, it runs in **demo mode**, filled with sample data, and saves only to your own browser.

## 2. Set up Supabase (about 5 minutes)

1. Go to [supabase.com](https://supabase.com), sign up, and click **New project**. Any name works; choose a region near you.
2. When the project is ready, open **SQL Editor** → **New query**, paste in all of `setup.sql`, and click **Run**. This creates the tables, the access rules and the `photos` bucket.
3. Click **Connect** at the top of the dashboard, or go to **Project Settings → API Keys**, and copy:
   - the **Project URL** (looks like `https://abcdefgh.supabase.co`)
   - the **anon / publishable key**. Use the public one, **never** the `service_role` / secret key.

## 3. Configure the site

Open `index.html`, find the `CONFIG` block near the top of the `<script>`, and fill it in:

```js
const CONFIG = {
  SUPABASE_URL: "https://abcdefgh.supabase.co",
  SUPABASE_KEY: "your-anon-or-publishable-key",
  GROUP_NAME: "Habit Squad",
  USERS: ["Alex", "Sam", "Jordan", ...],   // your group, up to 10
  BACKFILL_DAYS: 2                         // how far back people can check off missed days
};
```

## 4. Publish on GitHub Pages

1. On GitHub, create a new **public** repository, e.g. `habit-tracker`.
2. Click **Add file → Upload files**, drag in `index.html` (and this README if you like), then click **Commit**.
3. Go to **Settings → Pages**. Under *Build and deployment*, choose **Deploy from a branch**, branch **main**, folder **/ (root)**, then click **Save**.
4. After a minute or two, your site is live at `https://YOUR-GITHUB-NAME.github.io/habit-tracker/`.

Send that link to the group. On a phone, use **Share → Add to Home Screen** so it opens like an app.

To make changes later, edit `index.html` on GitHub. The site updates within a minute or two.

---

## How it works

- **My Day:** check off today's habits. You can tap ‹ to fill in the last couple of days, tap 📷 to attach a photo (which also checks the habit off), and use *Manage my habits* to add or archive habits.
- **Leaderboard:** ranks everyone by habits completed this week, this month or all time. It also shows completion % (so having more habits isn't an unfair advantage), current streak, today's progress, and a feed of recent photos.
- **Streaks** count consecutive days with at least one habit done.

## Good to know

- **No passwords means trust.** Anyone with the link can check in as anyone. Fine among friends; if it becomes a problem, you can add a shared group code.
- **The public key is meant to be public.** Supabase's anon/publishable key is designed to sit in website code. What people can do with it is limited by the rules in `setup.sql`.
- **Inactive free projects get paused.** Supabase may pause a free project after about a week with no activity. Daily use keeps it awake; if it ever pauses, restore it from the Supabase dashboard.
- **Storage:** photos are compressed in the browser to a few hundred KB each, so the free tier holds thousands of them.
