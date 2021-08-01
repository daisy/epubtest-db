\c :dbname;
set schema 'epubtest';

-- this role can access a limited number of tables
create role epubtest_readonly_role;
grant usage on schema epubtest to epubtest_readonly_role;

grant epubtest_public_role to epubtest_readonly_role;
grant epubtest_readonly_role to epubtest_app_role;
grant epubtest_readonly_role to epubtest_admin_role;

grant select on epubtest."PrivateAccessTokens" to epubtest_readonly_role;
create policy epubtest_readonly_AnswerSets
    on epubtest."PrivateAccessTokens" 
    to epubtest_readonly_role
    using(true);

grant select on epubtest."AnswerSets" to epubtest_readonly_role;
create policy epubtest_readonly_AnswerSets
    on epubtest."AnswerSets" 
    to epubtest_readonly_role
    using(true);

grant select on epubtest."Answers" to epubtest_readonly_role;
create policy epubtest_readonly_Answers
    on epubtest."Answers"
    to epubtest_readonly_role
    using(true);

grant select on epubtest."TestingEnvironments" to epubtest_readonly_role;
create policy epubtest_readonly_TestingEnvironments
    on epubtest."TestingEnvironments"
    to epubtest_readonly_role
    using(true);

grant select on epubtest."Softwares" to epubtest_readonly_role;
create policy epubtest_readonly_Softwares
    on epubtest."Softwares"
    to epubtest_readonly_role
    using(true);

grant select on epubtest."Users" to epubtest_readonly_role;
create policy epubtest_readonly_Users
    on epubtest."Users"
    to epubtest_readonly_role
    using(true);

