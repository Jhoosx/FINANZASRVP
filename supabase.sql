-- Pega todo esto en Supabase → SQL Editor → Run
create table if not exists public.gastos (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  amount numeric(12,2) not null check (amount > 0),
  cat text not null,
  note text default '',
  date date not null,
  created_at timestamptz default now()
);
create table if not exists public.presupuesto (
  user_id uuid primary key default auth.uid() references auth.users(id) on delete cascade,
  amount numeric(12,2) not null default 0
);
alter table public.gastos enable row level security;
alter table public.presupuesto enable row level security;
create policy "gastos propios" on public.gastos for all to authenticated
  using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "presupuesto propio" on public.presupuesto for all to authenticated
  using (auth.uid() = user_id) with check (auth.uid() = user_id);
