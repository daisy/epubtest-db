\c :dbname;
set schema 'epubtest';

-- get latest test books for language, ordered by topic order
drop function if exists epubtest.get_latest_test_books;
create or replace function epubtest.get_latest_test_books(
    lang text default 'en'
)
returns table (
    "id" integer,
    "title" text,
    "description" text,
    "filename" text,
    "lang_id" text,
    "version" text,
    "topic_id" text,
    "order" integer,
    "translation" boolean,
    "experimental" boolean
) as $$
declare
begin
    return query
    select 
        epubtest."TestBooks"."id",
        epubtest."TestBooks"."title", 
        epubtest."TestBooks"."description",
        epubtest."TestBooks"."filename", 
        epubtest."TestBooks"."lang_id",
        epubtest."TestBooks"."version",
        epubtest."TestBooks"."topic_id", 
        epubtest."Topics"."order",
        epubtest."TestBooks"."experimental",
        epubtest."TestBooks"."translation"
    from epubtest."TestBooks", epubtest."Topics"
    where
        epubtest."TestBooks"."lang_id" = lang
        and
        epubtest.is_latest_test_book(epubtest."TestBooks"."id")
        and
        epubtest."Topics"."id" = epubtest."TestBooks"."topic_id"
    order by
        epubtest."Topics"."order" asc;
end;
$$ language plpgsql stable;
