\c :dbname;

grant select, update, insert, delete on epubtest."OperatingSystems" to epubtest_app_role;
grant select, update, insert, delete on epubtest."Browsers" to epubtest_app_role;
grant select, update, insert, delete on epubtest."ReadingSystems" to epubtest_app_role;
grant select, update, insert, delete on epubtest."AssistiveTechnologies" to epubtest_app_role;
grant select, update, insert, delete on epubtest."AssistiveTechnologiesInAnswerSets" to epubtest_app_role;
grant select, update, insert, delete on epubtest."AssistiveTechnologiesInTestingEnvironments" to epubtest_app_role;

grant select, update, insert, delete on epubtest."OperatingSystems" to epubtest_admin_role;
grant select, update, insert, delete on epubtest."Browsers" to epubtest_admin_role;
grant select, update, insert, delete on epubtest."ReadingSystems" to epubtest_admin_role;
grant select, update, insert, delete on epubtest."AssistiveTechnologies" to epubtest_admin_role;
grant select, update, insert, delete on epubtest."AssistiveTechnologiesInAnswerSets" to epubtest_admin_role;
grant select, update, insert, delete on epubtest."AssistiveTechnologiesInTestingEnvironments" to epubtest_admin_role;

grant select on epubtest."OperatingSystems" to epubtest_user_role;
grant select on epubtest."Browsers" to epubtest_user_role;
grant select on epubtest."AssistiveTechnologies" to epubtest_user_role;
grant select on epubtest."ReadingSystems" to epubtest_user_role;
grant select, update on epubtest."AssistiveTechnologiesInAnswerSets" to epubtest_user_role;
grant select on epubtest."AssistiveTechnologiesInTestingEnvironments" to epubtest_user_role;

grant select on epubtest."OperatingSystems" to epubtest_public_role;
grant select on epubtest."Browsers" to epubtest_public_role;
grant select on epubtest."AssistiveTechnologies" to epubtest_public_role;
grant select on epubtest."ReadingSystems" to epubtest_public_role;
grant select on epubtest."AssistiveTechnologiesInAnswerSets" to epubtest_public_role;
grant select on epubtest."AssistiveTechnologiesInTestingEnvironments" to epubtest_public_role;

drop policy if exists epubtest_app_ReadingSystems on epubtest."ReadingSystems";
create policy epubtest_app_ReadingSystems
    on epubtest."ReadingSystems" 
    to epubtest_app_role
    using(true);

drop policy if exists epubtest_admin_ReadingSystems on epubtest."ReadingSystems";
create policy epubtest_admin_ReadingSystems
    on epubtest."ReadingSystems" 
    to epubtest_admin_role
    using(true);

drop policy if exists epubtest_user_ReadingSystems on epubtest."ReadingSystems";
create policy epubtest_user_ReadingSystems
    on epubtest."ReadingSystems"
    to epubtest_user_role
    using(
        exists(
            select epubtest."AnswerSets"."id", 
            epubtest."TestingEnvironments"."reading_system_id"
            from epubtest."AnswerSets", epubtest."TestingEnvironments"
            where 
                epubtest."AnswerSets"."user_id" = epubtest.current_user_id()
                and 
                epubtest."AnswerSets"."testing_environment_id" = epubtest."TestingEnvironments"."id"
                and
                epubtest."TestingEnvironments"."reading_system_id" = epubtest."ReadingSystems"."id"
    ));

-- TODO figure out why this policy was blocking public from seeing any results
drop policy if exists epubtest_public_ReadingSystems on epubtest."ReadingSystems";
create policy epubtest_public_ReadingSystems
    on epubtest."ReadingSystems"
    to epubtest_public_role
    using(
    --     exists(
    --         select *
    --         from epubtest."AnswerSets", epubtest."TestingEnvironments"
    --         where 
    --             epubtest."AnswerSets"."is_public" = true 
    --             and 
    --             epubtest."AnswerSets"."testing_environment_id" = epubtest."TestingEnvironments"."id"
    --             and
    --             epubtest."TestingEnvironments"."reading_system_id" = epubtest."ReadingSystems"."id"
    -- )
    true
);


