\c :dbname;
set schema 'epubtest';
-- is_tested field indicates that at least one answer has been recorded as something other than NOANSWER
alter table epubtest."AnswerSets" add column is_tested boolean default 'f';

drop function if exists epubtest.update_answer_set_is_tested;
create or replace function update_answer_set_is_tested()
returns trigger as $$
declare
    n int;
    begin
        select count(*) into n from epubtest."Answers" where 
            "Answers"."answer_set_id" = new."answer_set_id"
            and
            "Answers"."value" <> 'NOANSWER';
        if n = 0 then
            update epubtest."AnswerSets" set "is_tested" = 'f' where "id" = new."answer_set_id";
        else
            update epubtest."AnswerSets" set "is_tested" = 't' where "id" = new."answer_set_id";
        end if;
        return new;
    end;
$$ language plpgsql volatile;

-- this trigger occurs whenever an answer is changed
drop trigger if exists answer_set_is_tested_trigger on epubtest."Answers";
create trigger answer_set_is_tested_trigger after update on epubtest."Answers"
for each row execute procedure update_answer_set_is_tested();
