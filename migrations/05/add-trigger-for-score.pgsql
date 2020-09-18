\c :dbname;
set schema 'epubtest';

-- calculate the new score and update the answerset record
drop function if exists epubtest.update_score;
create or replace function update_score()
returns trigger as $$
declare
    new_score numeric;
    num_passes integer;
    num_total integer;
   begin
      select into num_passes count(*) from epubtest."Answers" where "answer_set_id" = new.answer_set_id and "value" = 'PASS';
      select into num_total count(*) from epubtest."Answers" where "answer_set_id" = new.answer_set_id;
      select into new_score round(((num_passes * 100.0) / num_total)::numeric, 2);
      update epubtest."AnswerSets" set "score" = new_score where "id" = new.answer_set_id;
      return new;
   end;
$$ language plpgsql volatile;

-- automatically update the score when the value of an answer changes
drop trigger if exists score_trigger on epubtest."Answers";
create trigger score_trigger after update of value on epubtest."Answers"
for each row execute procedure update_score();

