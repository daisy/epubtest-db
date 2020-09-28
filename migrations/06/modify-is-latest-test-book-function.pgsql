\c :dbname;
set schema 'epubtest';

/*
replacement function: uses new version schema

returns if given ID is for the latest version of the test book, for its language and topic
*/
drop function epubtest.is_latest_test_book;
create or replace function epubtest.is_latest_test_book(
    testBookId integer
)
returns boolean as $$
declare
    latest_id int;
    this_topic_id text;
    this_lang_id text;
begin
    select "topic_id", "lang_id" into this_topic_id, this_lang_id from epubtest."TestBooks" where "id" = testBookId;
    select "id" into latest_id from epubtest."TestBooks" 
        where "topic_id"=this_topic_id 
        and "lang_id" = this_lang_id
        order by "version_major" desc, "version_minor" desc, "version_patch" desc limit 1;
    return latest_id = testBookId;
end;
$$ language plpgsql stable;
