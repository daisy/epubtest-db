\c epubtest;
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


