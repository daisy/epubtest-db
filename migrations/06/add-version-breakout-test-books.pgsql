\c :dbname;
set schema 'epubtest';

alter table epubtest."TestBooks" add column "version_major" int;
alter table epubtest."TestBooks" add column "version_minor" int;
alter table epubtest."TestBooks" add column "version_patch" int;

-- we could make version be a generated column if we were using postgres 12 or later
-- but for now we'll do it with a trigger
drop function if exists epubtest.update_version_columns;
create or replace function update_version_columns()
returns trigger as $$
declare
    begin
        update epubtest."TestBooks" set "version_major" = (select regexp_split_to_array(epubtest."TestBooks"."version", E'\\.'))[1]::int 
            where epubtest."TestBooks"."id" = new."id";
        update epubtest."TestBooks" set "version_minor" = (select regexp_split_to_array(epubtest."TestBooks"."version", E'\\.'))[2]::int 
            where epubtest."TestBooks"."id" = new."id";
        update epubtest."TestBooks" set "version_patch" = (select regexp_split_to_array(epubtest."TestBooks"."version", E'\\.'))[3]::int 
            where epubtest."TestBooks"."id" = new."id";
        return new;
    end;
$$ language plpgsql volatile;

-- this trigger runs whenever a test book is created or its version is updated
drop trigger if exists update_version_columns_trigger on epubtest."TestBooks";
create trigger update_version_columns_trigger after insert or update of version on epubtest."TestBooks"
for each row execute procedure update_version_columns();


