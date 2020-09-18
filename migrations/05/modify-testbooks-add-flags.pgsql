\c :dbname;
set schema 'epubtest';

alter table epubtest."TestBooks" add column "translation" boolean not null default 'f';
alter table epubtest."TestBooks" add column "experimental" boolean not null default 'f';
