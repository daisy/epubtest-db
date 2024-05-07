\c :dbname;
set schema 'epubtest';

-- add field "is_latest" to test book
alter table epubtest."TestBooks" add column is_latest boolean default 'f';


-- a book is the latest if it has the latest version number for its topic
-- and its language is english
-- not sure how we will deal with translations but i don't want to complicate it now

-- add function to set is_latest where applicable on all books
drop function epubtest.update_test_books_is_latest;
create or replace function epubtest.update_test_books_is_latest()
returns void as $$
declare
begin
    update epubtest."TestBooks"
    set "is_latest"='f';
    
    update epubtest."TestBooks" 
    set "is_latest"='t' 
    where epubtest.is_latest_test_book(epubtest."TestBooks"."id");
end;
$$ language plpgsql volatile;

-- TODO finish this function