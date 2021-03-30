\c :dbname;
set schema 'epubtest';

-- is_migration indicates whether the user account was migrated from the old site
alter table epubtest."Users" add column is_migration boolean default 'f';
