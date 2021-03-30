\c :dbname;
set schema 'epubtest';

-- set the last modified timestamp for the answer and its answerset
drop function if exists epubtest.update_answer_last_modified;
create or replace function update_answer_last_modified()
returns trigger as $$
declare
   begin
      update epubtest."Answers" set "last_modified" = current_timestamp where "id" = new.id;
      update epubtest."AnswerSets" set "last_modified" = current_timestamp where "id" = new.answer_set_id;
      return new;
   end;
$$ language plpgsql volatile;

-- automatically update the last_modified timestamp when an answer value changes
drop trigger if exists answer_value_last_modified_trigger on epubtest."Answers";
create trigger answer_value_last_modified_trigger after insert or update of value on epubtest."Answers"
for each row execute procedure update_answer_last_modified();

-- automatically update the last_modified timestamp when an answer value changes
drop trigger if exists answer_notes_last_modified_trigger on epubtest."Answers";
create trigger answer_notes_last_modified_trigger after insert or update of notes on epubtest."Answers"
for each row execute procedure update_answer_last_modified();

-- set the last modified timestamp for an answerset
drop function if exists epubtest.update_answerset_last_modified;
create or replace function update_answerset_last_modified()
returns trigger as $$
declare
   begin
      update epubtest."AnswerSets" set "last_modified" = current_timestamp where "id" = new.id;
      return new;
   end;
$$ language plpgsql volatile;

-- automatically update the last_modified timestamp when an answerset summary changes
drop trigger if exists answerset_summary_last_modified_trigger on epubtest."AnswerSets";
create trigger answerset_summary_last_modified_trigger after insert or update of summary on epubtest."AnswerSets"
for each row execute procedure update_answerset_last_modified();



