-- KAVO Technologies database setup
-- FIRST create your sole admin in Supabase Authentication > Users.
-- Replace EVERY cf3cc4c0-4d53-41fa-81d5-4171ea164542 below with that user's exact UID.
-- Turn off public sign-ups. Never put a service-role/secret key in frontend files.
create extension if not exists pgcrypto;
create table if not exists public.bookings(id uuid primary key default gen_random_uuid(),name text not null,email text not null,phone text,service text not null,budget text,start_date date,details text not null,status text not null default 'new' check(status in('new','contacted','in_progress','completed','cancelled')),created_at timestamptz not null default now());
create table if not exists public.projects(id uuid primary key default gen_random_uuid(),title text not null,category text,description text,image_url text,project_url text,featured boolean not null default false,active boolean not null default true,sort_order integer not null default 10,created_at timestamptz not null default now());
create table if not exists public.services(id uuid primary key default gen_random_uuid(),name text not null,description text,active boolean not null default true,sort_order integer not null default 10,created_at timestamptz not null default now());
create table if not exists public.testimonials(id uuid primary key default gen_random_uuid(),client_name text not null,role text,quote text not null,active boolean not null default false,created_at timestamptz not null default now());
alter table public.bookings enable row level security;alter table public.projects enable row level security;alter table public.services enable row level security;alter table public.testimonials enable row level security;
drop policy if exists "Public can submit bookings" on public.bookings;drop policy if exists "Admin manages bookings" on public.bookings;
drop policy if exists "Public can view active projects" on public.projects;drop policy if exists "Admin manages projects" on public.projects;
drop policy if exists "Public can view active services" on public.services;drop policy if exists "Admin manages services" on public.services;
drop policy if exists "Public can view active testimonials" on public.testimonials;drop policy if exists "Admin manages testimonials" on public.testimonials;
create policy "Public can submit bookings" on public.bookings for insert to anon,authenticated with check(length(trim(name)) between 1 and 100 and length(trim(email)) between 3 and 160 and length(trim(service)) between 1 and 120 and length(trim(details)) between 1 and 3000);
create policy "Admin manages bookings" on public.bookings for all to authenticated using(auth.uid()='cf3cc4c0-4d53-41fa-81d5-4171ea164542'::uuid) with check(auth.uid()='cf3cc4c0-4d53-41fa-81d5-4171ea164542'::uuid);
create policy "Public can view active projects" on public.projects for select to anon,authenticated using(active=true);
create policy "Admin manages projects" on public.projects for all to authenticated using(auth.uid()='cf3cc4c0-4d53-41fa-81d5-4171ea164542'::uuid) with check(auth.uid()='cf3cc4c0-4d53-41fa-81d5-4171ea164542'::uuid);
create policy "Public can view active services" on public.services for select to anon,authenticated using(active=true);
create policy "Admin manages services" on public.services for all to authenticated using(auth.uid()='cf3cc4c0-4d53-41fa-81d5-4171ea164542'::uuid) with check(auth.uid()='cf3cc4c0-4d53-41fa-81d5-4171ea164542'::uuid);
create policy "Public can view active testimonials" on public.testimonials for select to anon,authenticated using(active=true);
create policy "Admin manages testimonials" on public.testimonials for all to authenticated using(auth.uid()='cf3cc4c0-4d53-41fa-81d5-4171ea164542'::uuid) with check(auth.uid()='cf3cc4c0-4d53-41fa-81d5-4171ea164542'::uuid);
insert into storage.buckets(id,name,public,file_size_limit,allowed_mime_types) values('portfolio-media','portfolio-media',true,5242880,array['image/jpeg','image/png','image/webp']) on conflict(id) do update set public=true,file_size_limit=5242880,allowed_mime_types=array['image/jpeg','image/png','image/webp'];
drop policy if exists "Public can view portfolio media" on storage.objects;drop policy if exists "Admin uploads portfolio media" on storage.objects;drop policy if exists "Admin updates portfolio media" on storage.objects;drop policy if exists "Admin deletes portfolio media" on storage.objects;
create policy "Public can view portfolio media" on storage.objects for select to anon,authenticated using(bucket_id='portfolio-media');
create policy "Admin uploads portfolio media" on storage.objects for insert to authenticated with check(bucket_id='portfolio-media' and auth.uid()='cf3cc4c0-4d53-41fa-81d5-4171ea164542'::uuid);
create policy "Admin updates portfolio media" on storage.objects for update to authenticated using(bucket_id='portfolio-media' and auth.uid()='cf3cc4c0-4d53-41fa-81d5-4171ea164542'::uuid) with check(bucket_id='portfolio-media' and auth.uid()='cf3cc4c0-4d53-41fa-81d5-4171ea164542'::uuid);
create policy "Admin deletes portfolio media" on storage.objects for delete to authenticated using(bucket_id='portfolio-media' and auth.uid()='cf3cc4c0-4d53-41fa-81d5-4171ea164542'::uuid);
insert into public.services(name,description,sort_order) values
('Website Design & Development','Responsive, modern websites that make your business stand out and turn visitors into customers.',1),
('Custom Software & Systems','Purpose-built platforms, dashboards and business tools designed around your workflow.',2),
('AI Solutions & Automation','Intelligent tools and automation to reduce repetitive work and improve efficiency.',3),
('Booking & Business Systems','Streamline appointments, enquiries, customer records and everyday operations.',4),
('Branding & Graphic Design','Consistent visual identities and digital graphics that help your brand get noticed.',5),
('Digital Business Solutions','Connected digital experiences that solve real problems and support growth.',6)
on conflict do nothing;
