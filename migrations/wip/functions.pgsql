\c :dbname;

create or replace function epubtest.answer_sets_have_same_ats(id1 int, id2 int)
returns boolean as $$
begin
    if (select count(*) from (
        (select "answer_set_id", "assistive_technology_in_testing_environment_id" from
            epubtest."AssistiveTechnologiesInAnswerSets" where "answer_set_id"=id1)
        except all
        (select "answer_set_id", "assistive_technology_in_testing_environment_id" from
            epubtest."AssistiveTechnologiesInAnswerSets" where "answer_set_id"=id2) 
    ) as foo)
    = 0 
    then
        return 't';
    else
        return 'f';
    end if;
end;
$$ language plpgsql stable;

/*
is_latest_answer_set (for topic, AT, and testing environment)
publicOnly: restrict to comparing to public answer sets
*/
create or replace function epubtest.is_latest_answer_set(
    answerSetId int,
    publicOnly boolean default 'f'
)
returns boolean as $$
declare
    topic text;
    version text;
    r record;
    this_version text;
    this_topic text;
begin
    version := epubtest.get_version_for_answerset(answerSetId);
    topic := epubtest.get_topic_for_answerset(answerSetId);
    
    -- for every (public) answer set for the testing environment of the given answer set
    for r in
        select epubtest."AnswerSets"."id", epubtest."AnswerSets"."testing_environment_id" 
        from epubtest."AnswerSets" 
        where 
        epubtest."AnswerSets"."testing_environment_id" = (
            select epubtest."AnswerSets"."testing_environment_id" 
            from epubtest."AnswerSets" 
            where epubtest."AnswerSets"."id" = answerSetId
            and
            (epubtest."AnswerSets"."is_public" = 't'
            or
            publicOnly = 'f')
        )
    loop
        -- the loop variable's topic and version
        this_topic := epubtest.get_topic_for_answerset(r."id");    
        this_version := epubtest.get_version_for_answerset(r."id");
        -- if it's an answerset for the same topic
        if this_topic = topic and 
        epubtest.answer_sets_have_same_ats(r."id", answerSetId) then
            -- if the version is less than anything else, it's not the latest
            if epubtest.compare_versions(version, this_version) = -1 then
                return false;
            end if;
        end if;

    end loop;
    return true;
end;
$$ language plpgsql stable;

