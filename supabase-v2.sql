-- Pega todo en Supabase → SQL Editor → Run (después de supabase.sql)
create table if not exists public.cuentas (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  nombre text not null,
  tipo text not null default 'banco' check (tipo in ('banco','credito','efectivo')),
  saldo numeric(12,2) not null default 0,
  created_at timestamptz default now()
);
alter table public.cuentas enable row level security;
create policy "cuentas propias" on public.cuentas for all to authenticated
  using (auth.uid() = user_id) with check (auth.uid() = user_id);
alter table public.gastos add column if not exists tipo text not null default 'gasto' check (tipo in ('gasto','ingreso'));
alter table public.gastos add column if not exists cuenta_id uuid references public.cuentas(id) on delete set null;
