\c epubtest;

drop role if exists epubtest_app_role;
create role epubtest_app_role with LOGIN password :'appRolePassword';

grant usage on schema epubtest to epubtest_app_role;
grant execute on all functions in schema epubtest to epubtest_app_role;
grant select, update, insert, delete on all tables in schema epubtest to epubtest_app_role;
grant all privileges on database epubtest to epubtest_app_role;
grant all privileges on all tables in schema epubtest to epubtest_app_role;

create policy epubtest_app_AnswerSets
    on epubtest."AnswerSets" 
    to epubtest_app_role
    using (true);

create policy epubtest_app_Answers
    on epubtest."Answers" 
    to epubtest_app_role
    using (true);

create policy epubtest_app_Softwares
    on epubtest."Softwares" 
    to epubtest_app_role
    using (true);

create policy epubtest_app_TestingEnvironments
    on epubtest."TestingEnvironments" 
    to epubtest_app_role
    using (true);

create policy epubtest_app_Users
    on epubtest."Users" 
    to epubtest_app_role
    using (true);

create policy epubtest_app_Logins
    on epubtest."Logins" 
    to epubtest_app_role
    using (true);