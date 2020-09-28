\c :dbname;
set schema 'epubtest';

/*
uses new version schema

is latest answer set for this topic and testing environment
*/
drop function epubtest.is_latest_answer_set;
create or replace function epubtest.is_latest_answer_set(
    answerSetId int,
    publicOnly boolean default 'f'
)
returns boolean as $$
declare
    this_topic_id text;
    this_testenv_id int;
    latest_id int;
begin
    select epubtest."TestBooks"."topic_id", epubtest."AnswerSets"."testing_environment_id" 
        into this_topic_id, this_testenv_id 
        from epubtest."TestBooks", epubtest."AnswerSets" 
        where epubtest."AnswerSets"."id" = answerSetId
        and epubtest."TestBooks"."id" = epubtest."AnswerSets"."test_book_id";
    
    select epubtest."AnswerSets"."id" 
        into latest_id 
        from epubtest."AnswerSets", epubtest."TestBooks" 
        where epubtest."TestBooks"."topic_id"=this_topic_id 
        and epubtest."AnswerSets"."testing_environment_id"=this_testenv_id
        and epubtest."TestBooks"."id" = epubtest."AnswerSets"."test_book_id"
        and (epubtest."AnswerSets"."is_public" = TRUE
            or
            publicOnly = FALSE)
        order by 
            epubtest."TestBooks"."version_major" desc, 
            epubtest."TestBooks"."version_minor" desc, 
            epubtest."TestBooks"."version_patch" desc 
        limit 1;
    return latest_id = answerSetId;    
end;
$$ language plpgsql stable;

-- declare
--     rec record;
--     topic text;
--     version text;
--     r record;
--     this_version text;
--     test_env_id int;
--     len int;
--     is_public boolean;
-- begin
--     version := epubtest.get_version_for_answerset(answerSetId);
--     topic := epubtest.get_topic_for_answerset(answerSetId);
--     select into is_public epubtest."AnswerSets".is_public from epubtest."AnswerSets" where epubtest."AnswerSets"."id" = answerSetId;
--     select into test_env_id epubtest."AnswerSets"."testing_environment_id" from epubtest."AnswerSets" where epubtest."AnswerSets"."id" = answerSetId;
    
--     for r in
--         select epubtest."AnswerSets"."id" from epubtest."AnswerSets", epubtest."TestBooks" 
--             where 
--             epubtest."AnswerSets"."testing_environment_id" = test_env_id 
--             and 
--             epubtest."AnswerSets"."test_book_id" = epubtest."TestBooks"."id" 
--             and epubtest."TestBooks"."topic_id" = topic
--             and
--             (epubtest."AnswerSets"."is_public" = TRUE
--             or
--             publicOnly = FALSE)
--     loop
--         this_version := epubtest.get_version_for_answerset(r."id");
--         -- if the version is less than anything else, it's not the latest
--         if epubtest.compare_versions(version, this_version) = -1 then
--             return false;
--         end if;

--     end loop;
--     -- if nothing has been returned yet, meaning either nothing was found to be based on an older test book,
--     -- or the loop did not iterate over anything (this would happen if there was only one non-public record, 
--     -- and we were looking only for public records):
--     -- decide whether the current answer set satisfies the requirements
--     if publicOnly = TRUE and is_public = FALSE then
--         return false;
--     end if;
--     return true;
-- end;
-- $$ language plpgsql stable;
