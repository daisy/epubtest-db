\c :dbname;
set schema 'epubtest';
-- the is_public field on testing environments is meant to indicate that the testing environment has one or more public answer sets
alter table epubtest."TestingEnvironments" add column is_public boolean default 'f';

drop function if exists epubtest.update_testing_environment_is_public;
create or replace function update_testing_environment_is_public()
returns trigger as $$
declare
    n int;
    begin
        raise notice 'trigger update_testing_environment_is_public';
        select count(*) into n from epubtest."AnswerSets" where 
            "AnswerSets"."testing_environment_id" = new."testing_environment_id"
            and
            "AnswerSets"."is_public" = 't';
        if n = 0 then
            update epubtest."TestingEnvironments" set "is_public" = 'f' where "id" = new."testing_environment_id";
        else
            update epubtest."TestingEnvironments" set "is_public" = 't' where "id" = new."testing_environment_id";
        end if;
        return new;
    end;
$$ language plpgsql volatile;

-- this trigger occurs whenever an answer set is created, deleted, or updated
drop trigger if exists testing_environment_is_public_trigger on epubtest."AnswerSets";
create trigger testing_environment_is_public_trigger after insert or delete or update of is_public on epubtest."AnswerSets"
for each row execute procedure update_testing_environment_is_public();
