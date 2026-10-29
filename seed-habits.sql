-- ============================================================
-- Habit Squad — fixed habit list with weekly targets.
-- Run AFTER setup.sql, in Supabase → SQL Editor. Safe to re-run.
-- ============================================================
alter table public.habits add column if not exists target     int     not null default 7;
alter table public.habits add column if not exists penalty    boolean not null default false;
alter table public.habits add column if not exists sort_order int     not null default 0;

-- Keep in sync with CONFIG.HABITS in index.html. penalty = each check-in costs 1 point.
with list(n, emoji, name, target, penalty, only_user) as (values
  (0,  '🥗', 'Salad bar',                           3, false, null),
  (1,  '💧', 'Drink 2 water bottles',               7, false, null),
  (2,  '☕', 'No coffee after 3 pm',                7, false, null),
  (3,  '🍫', 'Had M&Ms (−1 point)',                 0, true,  null),
  (4,  '🏃', 'Run',                                 3, false, null),
  (5,  '🍷', 'No weeknight drinking',               5, false, null),
  (6,  '🍪', 'No brownies or cookies at the office',5, false, null),
  (7,  '🍻', 'No buying other people drinks',       7, false, null),
  (8,  '💇', 'Start doing hair',                    5, false, 'Margaret'),
  (9,  '😴', 'Bed before 11 on work nights',        5, false, null),
  (10, '🍳', 'Cook healthy meals at home',          4, false, null),
  (11, '🏠', 'Disregard roommates',                 7, false, null),
  (12, '👗', 'Work outfits put together',           5, false, null)
), people(username) as (values ('Margaret'), ('Ella'))
insert into public.habits (username, name, emoji, target, penalty, sort_order)
select p.username, l.name, l.emoji, l.target, l.penalty, l.n
from list l
join people p on l.only_user is null or l.only_user = p.username
where not exists (
  select 1 from public.habits h where h.username = p.username and h.name = l.name
);
