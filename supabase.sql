-- Fixkosten-Rechner: Tabelle für die Daten jedes Kontos.
-- In Supabase unter "SQL Editor" einfügen und auf "Run" tippen.

create table if not exists public.budgets (
  user_id uuid primary key default auth.uid() references auth.users (id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.budgets enable row level security;

-- Jede Person sieht und ändert nur ihre eigene Zeile.
drop policy if exists "eigene Daten lesen" on public.budgets;
drop policy if exists "eigene Daten anlegen" on public.budgets;
drop policy if exists "eigene Daten ändern" on public.budgets;

create policy "eigene Daten lesen" on public.budgets
  for select to authenticated using ((select auth.uid()) = user_id);
create policy "eigene Daten anlegen" on public.budgets
  for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "eigene Daten ändern" on public.budgets
  for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

revoke all on public.budgets from anon;
grant select, insert, update on public.budgets to authenticated;
