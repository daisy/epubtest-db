\c :dbname;
set schema 'epubtest';

/*
remove the test book and related answer sets and answers
*/
drop function epubtest.delete_test_book_and_answer_sets;
create or replace function epubtest.delete_test_book_and_answer_sets(
    test_book_id int
)
returns void as $$
declare
    
begin
    -- these triggers are really slow and there's no reason to run them after every delete on AnswerSets
    perform epubtest.disable_triggers();

    -- delete the answers
    delete from epubtest."Answers" where epubtest."Answers"."answer_set_id" in 
        (select epubtest."AnswerSets"."id" from epubtest."AnswerSets" 
        where epubtest."AnswerSets"."test_book_id"=delete_test_book_and_answer_sets.test_book_id);
    -- delete the requests
    delete from epubtest."Requests" where epubtest."Requests"."answer_set_id" in 
        (select epubtest."AnswerSets"."id" from epubtest."AnswerSets" 
        where epubtest."AnswerSets"."test_book_id"=delete_test_book_and_answer_sets.test_book_id);
    raise notice 'deleting answer sets';
    delete from epubtest."AnswerSets" where epubtest."AnswerSets"."test_book_id"=delete_test_book_and_answer_sets.test_book_id;
    raise notice 'deleting tests';
    delete from epubtest."Tests" where epubtest."Tests"."test_book_id"=delete_test_book_and_answer_sets.test_book_id;
    raise notice 'deleting test book';
    delete from epubtest."TestBooks" where epubtest."TestBooks"."id"=delete_test_book_and_answer_sets.test_book_id;

    -- re-enable the triggers
    perform epubtest.enable_triggers();

    -- manually run the functions that the triggers would have run
    -- AnswerSets.is_latest
    update epubtest."AnswerSets" set "is_latest" = (select epubtest.is_latest_answer_set("AnswerSets"."id", FALSE));

    -- AnswerSets.is_latest_public
    update epubtest."AnswerSets" set "is_latest_public" = (select epubtest.is_latest_answer_set("AnswerSets"."id", TRUE));

    -- TestingEnvironments.is_public
    update epubtest."TestingEnvironments" set "is_public" = TRUE where (select count(*) from epubtest."AnswerSets" where
    epubtest."AnswerSets"."testing_environment_id" = "TestingEnvironments"."id" and epubtest."AnswerSets"."is_public" = TRUE) > 0;

end;
$$ language plpgsql volatile;
