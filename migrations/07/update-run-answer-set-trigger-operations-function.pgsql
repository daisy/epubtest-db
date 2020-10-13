\c :dbname;
set schema 'epubtest';

/*
performs what the triggers would have performed
useful when they had to be paused for large operations to improve performance
then run this function after

this is a modification from the original function to:
- update AnswerSets.is_tested 
- fix bug in update for TestingEnvironments.is_public
*/
drop function epubtest.run_answer_set_trigger_operations;
create or replace function epubtest.run_answer_set_trigger_operations()
returns void as $$
declare
    
begin
    -- TestingEnvironments.is_public
    update epubtest."TestingEnvironments" set "is_public" = ((select count(*) from epubtest."AnswerSets" where
    epubtest."AnswerSets"."testing_environment_id" = "TestingEnvironments"."id" and epubtest."AnswerSets"."is_public" = TRUE) > 0);

    -- AnswerSets.is_latest
    update epubtest."AnswerSets" set "is_latest" = (select epubtest.is_latest_answer_set("AnswerSets"."id", FALSE));

    -- AnswerSets.is_latest_public
    update epubtest."AnswerSets" set "is_latest_public" = (select epubtest.is_latest_answer_set("AnswerSets"."id", TRUE));

    -- AnswerSets.is_tested
    update epubtest."AnswerSets" set "is_tested" = ((select count(*) from epubtest."Answers" where epubtest."Answers"."value" <> 'NOANSWER' and 
    epubtest."Answers"."answer_set_id" = "AnswerSets"."id") > 0);
end;
$$ language plpgsql volatile;
