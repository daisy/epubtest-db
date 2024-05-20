\c :dbname
-- the download url is useful if the book is hosted remotely
alter table epubtest."TestBooks" add column if not exists "download_url" text default '';