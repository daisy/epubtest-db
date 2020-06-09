\c :dbname;
set schema 'epubtest';

create table if not exists epubtest."Invitations" (
    "id" serial primary key,
    "user_id" integer not null,
    "date_invited" timestamptz default current_timestamp,
    foreign key ("user_id") references epubtest."Users"("id")
);
alter table epubtest."Invitations" enable row level security;

grant select, update, insert, delete on epubtest."Invitations" to epubtest_admin_role;
grant usage on sequence epubtest."Invitations_id_seq" to epubtest_admin_role;

create policy epubtest_app_Invitations
    on epubtest."Invitations" 
    to epubtest_app_role
    using (true);

create policy epubtest_admin_Invitations
    on epubtest."Invitations" 
    to epubtest_admin_role
    using (true);

grant delete on epubtest."Invitations" to epubtest_user_role;
create policy epubtest_user_Invitations
    on epubtest."Invitations" 
    to epubtest_user_role
    using (epubtest."Invitations"."user_id" = epubtest.current_user_id());

grant usage on sequence epubtest."TestBooks_id_seq" to epubtest_admin_role;
grant usage on sequence epubtest."Tests_id_seq" to epubtest_admin_role;
grant usage on sequence epubtest."AnswerSets_id_seq" to epubtest_admin_role;
grant usage on sequence epubtest."Users_id_seq" to epubtest_admin_role;
grant usage on sequence epubtest."Logins_id_seq" to epubtest_admin_role;
grant usage on sequence epubtest."Answers_id_seq" to epubtest_admin_role;
grant usage on sequence epubtest."TestingEnvironments_id_seq" to epubtest_admin_role;
grant usage on sequence epubtest."Softwares_id_seq" to epubtest_admin_role;

-- reset the sequence counters
SELECT setval('"epubtest"."TestBooks_id_seq"', (SELECT MAX(id) FROM epubtest."TestBooks")+1);
SELECT setval('"epubtest"."Tests_id_seq"', (SELECT MAX(id) FROM epubtest."Tests")+1);
SELECT setval('"epubtest"."AnswerSets_id_seq"', (SELECT MAX(id) FROM epubtest."AnswerSets")+1);
SELECT setval('"epubtest"."Users_id_seq"', (SELECT MAX(id) FROM epubtest."Users")+1);
SELECT setval('"epubtest"."Logins_id_seq"', (SELECT MAX(id) FROM epubtest."Logins")+1);
SELECT setval('"epubtest"."Softwares_id_seq"', (SELECT MAX(id) FROM epubtest."Softwares")+1);  
SELECT setval('"epubtest"."TestingEnvironments_id_seq"', (SELECT MAX(id) FROM epubtest."TestingEnvironments")+1);
SELECT setval('"epubtest"."Answers_id_seq"', (SELECT MAX(id) FROM epubtest."Answers")+1);
SELECT setval('"epubtest"."Requests_id_seq"', (SELECT MAX(id) FROM epubtest."Requests")+1);
SELECT setval('"epubtest"."Invitations_id_seq"', (SELECT MAX(id) FROM epubtest."Invitations")+1);

ALTER TABLE epubtest."TestBooks" ALTER COLUMN ingested SET DEFAULT now();