-- ============================================================
-- Habit Squad — Supabase setup
-- Paste this whole file into Supabase → SQL Editor → Run.
-- Safe to run more than once.
-- ============================================================

-- Habits: each person's list of habits
create table if not exists public.habits (
  id          uuid primary key default gen_random_uuid(),
  username    text not null,
  name        text not null check (char_length(name) between 1 and 60),
  emoji       text default '✅',
  active      boolean not null default true,
  created_at  timestamptz not null default now(),
  archived_at timestamptz
);

-- Check-ins: one row per habit per day (optionally with a photo)
create table if not exists public.checkins (
  id         uuid primary key default gen_random_uuid(),
  username   text not null,
  habit_id   uuid not null references public.habits(id) on delete cascade,
  day        date not null,
  photo_url  text,
  created_at timestamptz not null default now(),
  unique (habit_id, day)
);

create index if not exists checkins_user_day on public.checkins (username, day);

-- ------------------------------------------------------------
-- Access rules. There are no passwords, so anyone with the site
-- (and therefore the public key) can read and write. Habits can
-- be archived but not deleted, so history can't be wiped from the site.
-- ------------------------------------------------------------
alter table public.habits   enable row level security;
alter table public.checkins enable row level security;

drop policy if exists "habits read"   on public.habits;
drop policy if exists "habits insert" on public.habits;
drop policy if exists "habits update" on public.habits;
create policy "habits read"   on public.habits for select to anon using (true);
create policy "habits insert" on public.habits for insert to anon with check (true);
create policy "habits update" on public.habits for update to anon using (true) with check (true);

drop policy if exists "checkins read"   on public.checkins;
drop policy if exists "checkins insert" on public.checkins;
drop policy if exists "checkins update" on public.checkins;
drop policy if exists "checkins delete" on public.checkins;
create policy "checkins read"   on public.checkins for select to anon using (true);
create policy "checkins insert" on public.checkins for insert to anon with check (true);
create policy "checkins update" on public.checkins for update to anon using (true) with check (true);
create policy "checkins delete" on public.checkins for delete to anon using (true);

grant select, insert, update         on public.habits   to anon;
grant select, insert, update, delete on public.checkins to anon;

-- ------------------------------------------------------------
-- Photo storage: a public bucket, 5 MB max per image
-- (the site shrinks photos to ~200–400 KB before uploading).
-- ------------------------------------------------------------
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('photos', 'photos', true, 5242880, array['image/jpeg','image/png','image/webp'])
on conflict (id) do nothing;

drop policy if exists "photos upload" on storage.objects;
create policy "photos upload" on storage.objects
  for insert to anon with check (bucket_id = 'photos');

-- Optional: only allow your group's usernames. Uncomment and edit to match CONFIG.USERS.
-- alter table public.habits   add constraint habits_known_user   check (username in ('Alex','Sam','Jordan'));
-- alter table public.checkins add constraint checkins_known_user check (username in ('Alex','Sam','Jordan'));
