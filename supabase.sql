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

-- "Konto löschen" in der App: jede Person kann nur ihr eigenes Konto löschen.
-- Die Zeile in budgets wird dabei automatisch mitgelöscht (on delete cascade).
create or replace function public.delete_my_account()
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if auth.uid() is null then
    raise exception 'nicht angemeldet';
  end if;
  delete from auth.users where id = auth.uid();
end;
$$;

revoke all on function public.delete_my_account() from public, anon;
grant execute on function public.delete_my_account() to authenticated;
