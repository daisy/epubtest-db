-- some of this didn't go through with migration 15
-- it doesn't hurt to repeat it all again
\c :dbname
create type epubtest.request_type as enum('PUBLISH', 'UNPUBLISH');
-- request_type is somehow already in there so the above 'create' statement may not work
-- just in case, add the new value explicitly
alter type epubtest.request_type add value 'UNPUBLISH';
alter table epubtest."Requests" drop column if exists "type";
alter table epubtest."Requests" add column if not exists "req_type" epubtest.request_type default 'PUBLISH';
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE epubtest."Requests" TO epubtest_user_role;

