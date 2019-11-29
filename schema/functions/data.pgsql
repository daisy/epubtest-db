\c epubtest;


/*
versions must be "1.2.3" MAJ.MIN.PATCH format

v1 < v2 ? -1
v1 = v2 ? 0 
v1 > v2 ? 1

ignorePatch = ignore patch version number
*/
create or replace function epubtest.compare_versions(
    v1 text, 
    v2 text,
    ignorePatch boolean default false
)
returns integer as $$
declare
    v1arr int[];
    v2arr int[];
begin
    select into v1arr regexp_split_to_array(v1, E'\\.');
    select into v2arr regexp_split_to_array(v2, E'\\.');
    if v1arr[1] = v2arr[1] then
        if v1arr[2] = v2arr[2] then
            if ignorePatch then
                return 0;
            else
                if v1arr[3] = v2arr[3] then
                    return 0;
                else
                    if v1arr[3] > v2arr[3] then
                        return 1;
                    else /*v1arr[3] > v2arr[3]*/
                        return -1;
                    end if;
                end if;
            end if;
        else
            if v1arr[2] > v2arr[2] then
                return 1;
            else /*v1arr[2] > v2arr[2]*/
                return -1;
            end if;
        end if;
    else
        if v1arr[1] > v2arr[1] then
            return 1;
        else /*v1arr[1] < v2arr[1] */
            return -1;
        end if;
    end if;
end;
$$ language plpgsql stable;



/* 

get topic 
(internal helper function)
*/
create or replace function epubtest.get_topic_for_answerset(
    answerSetId int
)
returns text as $$
declare
    topic text;
begin
    select into topic epubtest."TestBooks"."topic_id"
    from epubtest."TestBooks", epubtest."AnswerSets"
    where epubtest."AnswerSets"."id"=answerSetId and epubtest."TestBooks"."id"=epubtest."AnswerSets"."test_book_id";
    return topic;
end;
$$ language plpgsql stable;


/*

get version
(internal helper function)
*/
create or replace function epubtest.get_version_for_answerset(
    answerSetId int
)
returns text as $$
declare
    version text;
begin
    select into version epubtest."TestBooks"."version"
    from epubtest."TestBooks", epubtest."AnswerSets"
    where epubtest."AnswerSets"."id"=answerSetId and epubtest."TestBooks"."id"=epubtest."AnswerSets"."test_book_id";
    return version;
end;
$$ language plpgsql stable;


/*
is_latest_answer_set (for topic and testing environment)
publicOnly: restrict to comparing to public answer sets
*/
create or replace function epubtest.is_latest_answer_set(
    answerSetId int,
    publicOnly boolean default 'f'
)
returns boolean as $$
declare
    rec record;
    topic text;
    version text;
    r record;
    this_version text;
    this_topic text;
begin
    version := epubtest.get_version_for_answerset(answerSetId);
    topic := epubtest.get_topic_for_answerset(answerSetId);
    
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
        this_topic := epubtest.get_topic_for_answerset(r."id");    
        this_version := epubtest.get_version_for_answerset(r."id");
        raise notice 'hi % %', this_version, this_topic;
        if this_topic = topic then
            -- if the version is less than anything else, it's not the latest
            if epubtest.compare_versions(version, this_version) = -1 then
                return false;
            end if;
        end if;

    end loop;
    return true;
end;
$$ language plpgsql stable;


-- get testing environments with their latest public non-archived answer sets
create or replace function epubtest.get_published_testing_environments()
returns setof epubtest."TestingEnvironments" as $$
declare

begin
    return query
    select * from epubtest."TestingEnvironments" 
        where 
            "id" in (
                select distinct(epubtest."TestingEnvironments"."id") 
                from epubtest."TestingEnvironments", epubtest."AnswerSets" 
                where 
                    epubtest."TestingEnvironments"."is_archived" = 'f'
                    and
                    epubtest."AnswerSets"."is_public" = 't' 
                    and 
                    epubtest."AnswerSets"."testing_environment_id" = epubtest."TestingEnvironments"."id" 
                    and 
                    epubtest.is_latest_answer_set(epubtest."AnswerSets"."id", 't'));
end;
$$ language plpgsql stable;

-- get testing environments for a user 
create or replace function epubtest.get_user_testing_environments(user_id int)
returns setof epubtest."TestingEnvironments" as $$
declare

begin
    return query
    select * from epubtest."TestingEnvironments"
        where 
            "id" in (
                select distinct(epubtest."TestingEnvironments"."id") 
                from epubtest."TestingEnvironments", epubtest."AnswerSets" 
                where 
                    epubtest."AnswerSets"."user_id" = $1 
                    and 
                    epubtest."AnswerSets"."testing_environment_id" = epubtest."TestingEnvironments"."id");
end;
$$ language plpgsql stable;

/*

is_latest_test_book (for topic and language)
*/
create or replace function epubtest.is_latest_test_book(
    testBookId integer
)
returns boolean as $$
declare
    rec record;
    r record;
begin
    select into rec "version", "topic_id", "lang_id" from epubtest."TestBooks" where epubtest."TestBooks"."id" = testBookId;
    for r in
        select *
        from epubtest."TestBooks" 
        where 
            epubtest."TestBooks"."lang_id" = rec."lang_id"
            and
            epubtest."TestBooks"."topic_id" = rec."topic_id"
    loop
        if epubtest.compare_versions(rec."version", r."version") = -1 then
            return false;
        end if;
    end loop;
    return true;
end;
$$ language plpgsql stable;


-- get latest test books for language, ordered by topic order
create or replace function epubtest.get_latest_test_books(
    lang text default 'en'
)
returns table (
    "id" integer,
    "title" text,
    "description" text,
    "filename" text,
    "lang_id" text,
    "topic_id" text,
    "order" integer
) as $$
declare
begin
    return query
    select 
        epubtest."TestBooks"."id",
        epubtest."TestBooks"."title", 
        epubtest."TestBooks"."description",
        epubtest."TestBooks"."filename", 
        epubtest."TestBooks"."lang_id",
        epubtest."TestBooks"."topic_id", 
        epubtest."Topics"."order" 
    from epubtest."TestBooks", epubtest."Topics"
    where
        epubtest."TestBooks"."lang_id" = lang
        and
        epubtest.is_latest_test_book(epubtest."TestBooks"."id")
        and
        epubtest."Topics"."id" = epubtest."TestBooks"."topic_id"
    order by
        epubtest."Topics"."order" asc;
end;
$$ language plpgsql stable;

create or replace function epubtest.update_answerset_and_answers(
    answer_set_id integer, 
    summary text,
    answer_ids integer[], 
    answer_values epubtest.answer_value[],
    notes text[],
    notes_are_public boolean[],
    score numeric)
returns void as $$
declare
    i int;
begin
    for i in 1 .. array_upper(answer_ids, 1)
    loop
        update epubtest."Answers" set 
        "value"=answer_values[i],
        "notes"=update_answerset_and_answers.notes[i],
        "notes_are_public"=update_answerset_and_answers.notes_are_public[i] 
        where "id"=answer_ids[i];
    end loop;
    
    update epubtest."AnswerSets" 
    set "summary"=update_answerset_and_answers.summary,
    "score"=update_answerset_and_answers.score
    where "id"=answer_set_id;

end;
$$ language plpgsql VOLATILE strict;


/* TODO
a fast way to sort natively on a semver field
but semver plugin isn't supported by amazon rds yet
*/
/* until then, this sql function is not the most efficient (yet) but it does the trick */
/*
    get_latest_answer_sets
*/
-- create or replace function epubtest.get_latest_answer_sets()
-- returns setof epubtest."AnswerSets" as $$
-- declare
    
-- begin
--     return query 
--     select *
--     from epubtest."AnswerSets" 
--     where (epubtest.is_latest_answer_set("id"))
--     order by "testing_environment_id";
-- end; 
-- $$ language plpgsql stable;

-- latest answer sets for test env
-- create or replace function epubtest.get_latest_answer_sets(testingEnvironmentId int)
-- returns setof epubtest."AnswerSets" as $$
-- declare
    
-- begin
--     return query 
--     select *
--     from epubtest."AnswerSets" 
--     where (epubtest.is_latest_answer_set("id") 
--     and 
--     epubtest."AnswerSets".testing_environment_id = testingEnvironmentId)
--     order by "testing_environment_id";
-- end; 
-- $$ language plpgsql stable;

