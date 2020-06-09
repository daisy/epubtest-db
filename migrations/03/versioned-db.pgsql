\c :dbname;
set schema 'epubtest';
create table if not exists epubtest."DbInfo" (
    "field" text primary key,
    "value" text not null
);
grant select, update, insert, delete on epubtest."DbInfo" to epubtest_admin_role;

insert into epubtest."DbInfo"("field", "value") values ('version', '03');
