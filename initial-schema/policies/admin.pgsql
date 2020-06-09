\c :dbname;
drop role if exists epubtest_admin_role;
create role epubtest_admin_role;

grant usage on schema epubtest to epubtest_admin_role;
grant select, update, insert, delete on all tables in schema epubtest to epubtest_admin_role;

grant all on all sequences in schema epubtest to epubtest_admin_role;

grant epubtest_admin_role to epubtest_app_role;

create policy epubtest_admin_AnswerSets
    on epubtest."AnswerSets" 
    to epubtest_admin_role
    using(true);

create policy epubtest_admin_Answers
    on epubtest."Answers" 
    to epubtest_admin_role
    using(true);

create policy epubtest_admin_Softwares
    on epubtest."Softwares" 
    to epubtest_admin_role
    using(true);

create policy epubtest_admin_TestingEnvironments
    on epubtest."TestingEnvironments" 
    to epubtest_admin_role
    using(true);

create policy epubtest_admin_Users
    on epubtest."Users" 
    to epubtest_admin_role
    using(true);

create policy epubtest_admin_Logins
    on epubtest."Logins" 
    to epubtest_admin_role
    using(true);
