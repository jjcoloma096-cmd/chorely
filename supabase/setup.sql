-- Chorely database setup: paste all of this into Supabase -> SQL Editor -> Run

create table profiles (
  id uuid primary key references auth.users on delete cascade,
  name text not null
);

create table chores (
  id bigint generated always as identity primary key,
  owner uuid not null default auth.uid() references profiles(id) on delete cascade,
  title text not null,
  due_date date not null,
  status text not null default 'pending' check (status in ('later','pending','done')),
  done_at timestamptz,
  photo_path text
);

alter table profiles enable row level security;
alter table chores enable row level security;

create policy "see everyone" on profiles for select to authenticated using (true);
create policy "make own profile" on profiles for insert to authenticated with check (id = auth.uid());
create policy "see all chores" on chores for select to authenticated using (true);
create policy "add own chores" on chores for insert to authenticated with check (owner = auth.uid());
create policy "change own chores" on chores for update to authenticated using (owner = auth.uid());

-- the server clock stamps the time a chore is marked done
create function set_done() returns trigger language plpgsql as $$
begin
  if new.status = 'done' then
    if tg_op = 'INSERT' or old.status <> 'done' then new.done_at := now(); end if;
  else
    new.done_at := null; new.photo_path := null;
  end if;
  return new;
end $$;
create trigger chores_done before insert or update on chores for each row execute function set_done();

-- private photo storage
insert into storage.buckets (id, name, public) values ('proof', 'proof', false) on conflict do nothing;
create policy "see proof photos" on storage.objects for select to authenticated using (bucket_id = 'proof');
create policy "upload own proof" on storage.objects for insert to authenticated
  with check (bucket_id = 'proof' and (storage.foldername(name))[1] = auth.uid()::text);
