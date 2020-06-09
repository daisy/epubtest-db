\c :dbname;
drop role if exists epubtest_public_role;
create role epubtest_public_role;
alter default privileges revoke execute on functions from epubtest_public_role;

grant usage on schema epubtest to epubtest_public_role;

grant epubtest_public_role to epubtest_app_role;

/* 
    AnswerSets

    public can view only public answer sets
*/
grant select on epubtest."AnswerSets" to epubtest_public_role;
create policy epubtest_public_AnswerSets
    on epubtest."AnswerSets" 
    to epubtest_public_role
    using (epubtest."AnswerSets"."is_public" = true);


/* 
    Answers

    public can view only public answers
*/
grant select on epubtest."Answers" to epubtest_public_role;
create policy epubtest_public_Answers
    on epubtest."Answers"
    to epubtest_public_role
    using(
        exists(
            select "id" 
            from epubtest."AnswerSets"
            where 
                epubtest."AnswerSets"."is_public" = true 
                and 
                epubtest."AnswerSets"."id" = epubtest."Answers"."answer_set_id"
    ));

/* 
    Langs     
*/
grant select on epubtest."Langs" to epubtest_public_role;

/*
    Softwares

    when they have public answer sets
*/
grant select on epubtest."Softwares" to epubtest_public_role;
create policy epubtest_public_Softwares
    on epubtest."Softwares"
    to epubtest_public_role
    using(
        exists(
            select epubtest."AnswerSets"."id", epubtest."TestingEnvironments"."id", epubtest."TestingEnvironments"."reading_system_id", epubtest."TestingEnvironments"."assistive_technology_id", epubtest."TestingEnvironments"."os_id", epubtest."TestingEnvironments"."browser_id", epubtest."TestingEnvironments"."device_id"
            from epubtest."AnswerSets", epubtest."TestingEnvironments"
            where 
                epubtest."AnswerSets"."is_public" = true 
                and 
                epubtest."AnswerSets"."testing_environment_id" = epubtest."TestingEnvironments"."id"
                and
                (epubtest."TestingEnvironments"."reading_system_id" = epubtest."Softwares"."id"
                or
                epubtest."TestingEnvironments"."assistive_technology_id" = epubtest."Softwares"."id"
                or
                epubtest."TestingEnvironments"."os_id" = epubtest."Softwares"."id"
                or
                epubtest."TestingEnvironments"."browser_id" = epubtest."Softwares"."id"
                or
                epubtest."TestingEnvironments"."device_id" = epubtest."Softwares"."id")
    ));


/* 
    TestBooks
*/
grant select on epubtest."TestBooks" to epubtest_public_role;

/*
    TestingEnvironments

    public can view only testing environments with public answer sets
*/
grant select on epubtest."TestingEnvironments" to epubtest_public_role;
create policy epubtest_public_TestingEnvironments
    on epubtest."TestingEnvironments"
    to epubtest_public_role
    using(
        exists(
            select "id" 
            from epubtest."AnswerSets" 
            where 
                epubtest."AnswerSets"."testing_environment_id" = epubtest."TestingEnvironments"."id" 
                and 
                epubtest."AnswerSets"."is_public" = true
    )); 


/* 
    Tests
*/
grant select on epubtest."Tests" to epubtest_public_role;

/* 
    Topics
*/
grant select on epubtest."Topics" to epubtest_public_role;

/*
    Users

    View profile info of users who've made something public
*/
grant select on epubtest."Users" to epubtest_public_role;
create policy epubtest_public_Users
    on epubtest."Users"
    for select
    to epubtest_public_role
    using(
        exists(
            select "id" 
            from epubtest."AnswerSets"
            where 
                epubtest."AnswerSets"."is_public" = true 
                and 
                epubtest."AnswerSets"."user_id" = epubtest."Users"."id"
    ));


/* 
    Logins
*/
revoke all on epubtest."Logins" from epubtest_public_role;
