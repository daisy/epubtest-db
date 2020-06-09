\c :dbname;

drop role if exists epubtest_user_role;
create role epubtest_user_role;

/* 
    AnswerSets

    user can view own answer sets
*/
grant select, update on epubtest."AnswerSets" to epubtest_user_role;
create policy epubtest_user_AnswerSets
    on epubtest."AnswerSets" 
    to epubtest_user_role
    using (epubtest."AnswerSets"."user_id" = epubtest.current_user_id());

/* 

Answers 


*/
grant select, update on epubtest."Answers" to epubtest_user_role;
create policy epubtest_user_Answers
    on epubtest."Answers"
    to epubtest_user_role
    using (
        exists (
            select "id" 
            from epubtest."AnswerSets" where
            (
                epubtest."AnswerSets"."user_id" = epubtest.current_user_id()
                and
                epubtest."AnswerSets"."id" = "Answers"."answer_set_id"
            )
        )
    );


/*
Langs
*/
grant select on epubtest."Langs" to epubtest_user_role;

/*
Softwares
*/
grant select on epubtest."Softwares" to epubtest_user_role;
create policy epubtest_user_Softwares
    on epubtest."Softwares"
    to epubtest_user_role
    using(
        exists(
            select epubtest."AnswerSets"."id", epubtest."TestingEnvironments"."id", epubtest."TestingEnvironments"."reading_system_id", epubtest."TestingEnvironments"."assistive_technology_id", epubtest."TestingEnvironments"."os_id", epubtest."TestingEnvironments"."browser_id", epubtest."TestingEnvironments"."device_id"
            from epubtest."AnswerSets", epubtest."TestingEnvironments"
            where 
                epubtest."AnswerSets"."user_id" = epubtest.current_user_id()
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
grant select on epubtest."TestBooks" to epubtest_user_role;

/*
TestingEnvironments
*/
grant select on epubtest."TestingEnvironments" to epubtest_user_role;
create policy epubtest_user_TestingEnvironments
    on epubtest."TestingEnvironments"
    to epubtest_user_role
    using (
        exists (
            select "id" 
            from epubtest."AnswerSets" where
            (
                epubtest."AnswerSets"."user_id" = epubtest.current_user_id()
                and
                epubtest."AnswerSets"."testing_environment_id" = "TestingEnvironments"."id"
            )
        )
    );
/*
Tests
*/
grant select on epubtest."Tests" to epubtest_user_role;

/*
Topics
*/
grant select on epubtest."Topics" to epubtest_user_role;

/*
Users
*/
grant select, update on epubtest."Users" to epubtest_user_role;
create policy epubtest_user_Users
    on epubtest."Users"
    to epubtest_user_role
    using (epubtest."Users"."id" = epubtest.current_user_id());

/*
Logins
*/
grant update("password") on epubtest."Logins" to epubtest_user_role;
create policy epubtest_user_Logins
    on epubtest."Logins"
    to epubtest_user_role
    using (
        exists(
            select "login_id", "id" 
            from epubtest."Users"
            where epubtest."Users"."id" = epubtest.current_user_id()
            and
            epubtest."Users"."login_id" = epubtest."Logins"."id"
        )
    );



/*
    Requests
*/
grant select, insert on epubtest."Requests" to epubtest_user_role;
grant usage on sequence epubtest."Requests_id_seq" to epubtest_user_role;

grant epubtest_public_role to epubtest_user_role;
grant epubtest_user_role to epubtest_app_role;
