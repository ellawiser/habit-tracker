# Habit Squad: Agent Build Plan

You are working in the `habit-tracker` folder. It contains a working first version of a shared habit tracker for a group of up to 10 friends. Your job is to finish setup, deploy it to GitHub Pages, and polish it.

**Before each phase:** tell me what you're about to do. Ask me for any information you need (names, keys, choices) instead of guessing.

---

## Project overview

- **What it is:** a mobile-friendly website where each friend picks their name (no passwords), tracks daily habits, attaches photos, and competes on a shared leaderboard.
- **Hosting:** GitHub Pages. This means static files only, with no server code.
- **Backend:** Supabase on the free tier. The site uses its Postgres database for habits and check-ins, and its Storage bucket for photos. The browser talks to Supabase directly with the public anon/publishable key.

## Files that already exist

| File | Purpose |
|---|---|
| `index.html` | The entire app: HTML, CSS and vanilla JS in one file. It loads `@supabase/supabase-js@2` from the jsDelivr CDN. |
| `setup.sql` | Creates the `habits` and `checkins` tables, the row-level security policies, and the public `photos` storage bucket. Safe to re-run. |
| `README.md` | Human-readable setup and deploy instructions. |

### How `index.html` works

- **Configuration:** a `CONFIG` object at the top of the `<script>` holds `SUPABASE_URL`, `SUPABASE_KEY`, `GROUP_NAME`, `USERS` (up to 10 names) and `BACKFILL_DAYS`.
- **Demo mode:** if `SUPABASE_URL` or `SUPABASE_KEY` is empty, the app runs in demo mode with seeded fake data saved in `localStorage`.
- **Data layer:** `supabaseApi()` and `demoApi()` expose the same interface: `habits`, `checkins`, `addHabit`, `archiveHabit`, `check`, `uncheck`, `setPhoto`, `uploadPhoto`.
- **Tabs:**
  - **My Day:** a day navigator, habit checkboxes, a 📷 photo upload per habit (which also checks the habit off), a stats row, and "Manage my habits" for adding or archiving habits.
  - **Leaderboard:** week, month and all-time views ranked by completions, with completion %, streak, today's progress, and a recent-photos feed.
- **Photos:** compressed in the browser with a canvas (max 1280px, JPEG) before upload.
- **Data model:**
  - `habits`: id, username, name, emoji, active, created_at, archived_at
  - `checkins`: id, username, habit_id, day, photo_url, created_at, with a unique key on (habit_id, day)

## Rules

- Keep it a **single static `index.html`**. Don't add a build step, framework, bundler or server code.
- **Never** put a Supabase `service_role` or secret key in any file. Only the anon/publishable key belongs in `CONFIG`.
- Don't commit anything secret. The anon key is fine to commit; it's designed to be public.
- Keep demo mode working. It's how we test without touching real data.
- After any change to `index.html`, test it in the browser in demo mode before committing.

---

## Phase 1: Configure

1. Ask me for:
   - the group name
   - the list of friend names (up to 10)
   - my Supabase **Project URL** and **anon/publishable key**
2. Update `CONFIG` in `index.html` with those values.
3. If I don't have a Supabase project yet:
   - Walk me through creating one at supabase.com.
   - Have me paste `setup.sql` into **SQL Editor** and click **Run**.
   - Have me copy the URL and key from **Connect** or from **Project Settings → API Keys**.
   - These are dashboard steps; I do them myself.
4. Optional: if I want only our names allowed in the database, uncomment and fill in the username `check` constraints at the bottom of `setup.sql`, then have me re-run it.

**Done when:** `CONFIG` is filled in and `setup.sql` has been run.

## Phase 2: Test against the real backend

1. Open `index.html` locally, either with VS Code's Live Server extension or with `python3 -m http.server`.
2. Verify the full flow:
   - pick a name
   - add a habit
   - check it off and uncheck it
   - upload a photo and confirm a thumbnail appears
   - see the leaderboard update
   - reload the page and confirm the data persists
3. If anything fails, read the browser console and the Supabase error message. Fix the cause, which is usually an RLS policy, a missing grant, or the storage bucket.
4. Delete any test rows I don't want to keep. Ask me first.

**Done when:** every step works with no console errors.

## Phase 3: Put it on GitHub and deploy

1. Initialize a git repo, if there isn't one, with `main` as the branch.
2. Add a `.gitignore` containing `.DS_Store` and `.vscode/`.
3. Commit the files.
4. Create a **public** GitHub repo named `habit-tracker`. Use the `gh` CLI if it's installed and logged in; otherwise have me use **Publish to GitHub** in VS Code's Source Control panel.
5. Push to `main`.
6. Enable GitHub Pages from **main / (root)**. Use `gh api` if possible, otherwise walk me through **Settings → Pages**.
7. Wait for the deploy and open `https://<username>.github.io/habit-tracker/` to confirm it loads and connects to Supabase (no demo banner).

**Done when:** the live URL works on desktop and on my phone.

## Phase 4: Polish (do in order, check with me before each)

1. **Home-screen app:** add a `manifest.webmanifest` and an app icon (an SVG or PNG generated from the 🔥 emoji is fine) so "Add to Home Screen" gives a proper icon and name.
2. **Live updates:** subscribe to Supabase Realtime on `checkins` so the leaderboard updates without the 60-second refresh. Remember that Realtime has to be enabled for the table in Supabase.
3. **Delete photo:** add a way to remove a photo from a check-in without unchecking the habit.
4. **Weekly winner:** add a banner at the top of the leaderboard showing last week's winner.
5. **Optional group code:** a shared passcode prompt on first visit, stored in `localStorage`. It's a light barrier, not real security, and I'll decide whether we want it.

After each polish item:
- test in demo mode
- commit with a clear message
- push
- confirm the live site updates

---

## Final checklist

- [ ] `CONFIG` has the real names, URL and anon key, and no secret keys.
- [ ] The full flow works on the live GitHub Pages URL.
- [ ] It works on a phone, including photo upload from the camera roll.
- [ ] `README.md` is updated to reflect any new features or setup steps.
- [ ] Tell me the live URL and summarize what changed.
