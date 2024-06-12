\c :dbname
create type epubtest.request_type as enum('PUBLISH', 'UNPUBLISH');
alter table epubtest."Requests" add column if not exists "req_type" epubtest.request_type default 'PUBLISH';
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE epubtest."Requests" TO epubtest_user_role;

