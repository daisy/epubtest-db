\c :dbname;
set schema 'epubtest';
alter table epubtest."Softwares" add column if not exists "active" boolean default true;

