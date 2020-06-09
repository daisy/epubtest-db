\c :dbname;
set schema 'epubtest';

-- get inactive users
DROP FUNCTION if exists get_inactive_users();
create or replace function epubtest.get_inactive_users()
returns table (
    "id" integer,
    "name" text,
    "email" text
) as $$
declare

begin
    return query
    select "Users"."id", "Users"."name", "Logins"."email" from epubtest."Users", epubtest."Logins" 
    where "Users"."login_id" = "Logins"."id" and "Logins"."active" = FALSE;
end;
$$ language plpgsql stable;

-- get active users
create or replace function epubtest.get_active_users()
returns table (
    "id" integer,
    "name" text
) as $$
declare

begin
    return query
    select "Users"."id", "Users"."name" from epubtest."Users", epubtest."Logins" 
    where "Users"."login_id" = "Logins"."id" and "Logins"."active" = TRUE;
end;
$$ language plpgsql stable;

-- bug fix from original function 
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
    if array_length(answer_ids, 1) != 0 then
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
    end if;
end;
$$ language plpgsql VOLATILE strict;

-- get archived testing environments with public answer sets
create or replace function epubtest.get_archived_testing_environments()
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
                    epubtest."TestingEnvironments"."is_archived" = 't'
                    and
                    epubtest."AnswerSets"."is_public" = 't' 
                    and 
                    epubtest."AnswerSets"."testing_environment_id" = epubtest."TestingEnvironments"."id" 
                    );
end;
$$ language plpgsql stable;

-- get latest test books for language, ordered by topic order
drop function if exists epubtest.get_latest_test_books;
create or replace function epubtest.get_latest_test_books(
    lang text default 'en'
)
returns table (
    "id" integer,
    "title" text,
    "description" text,
    "filename" text,
    "lang_id" text,
    "version" text,
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
        epubtest."TestBooks"."version",
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
