\c :dbname;
set schema 'epubtest';

-- the is_latest field is on an answer set and indicates that the answer set is for the latest version of a test book for a topic
alter table epubtest."AnswerSets" add column is_latest boolean default 't';
alter table epubtest."AnswerSets" add column is_latest_public boolean default 'f';

drop function if exists epubtest.update_answer_set_is_latest;
create or replace function update_answer_set_is_latest()
returns trigger as $$
declare
    begin
        update epubtest."AnswerSets" set 
            "is_latest" = (select epubtest.is_latest_answer_set("AnswerSets"."id", FALSE)),
            "is_latest_public" = (select epubtest.is_latest_answer_set("AnswerSets"."id", TRUE));
        return new;
    end;
$$ language plpgsql volatile;

-- this trigger runs whenever an answer set is created or deleted
drop trigger if exists answer_set_is_latest_trigger on epubtest."AnswerSets";
create trigger answer_set_is_latest_trigger after insert or delete or update of is_public on epubtest."AnswerSets"
for each row execute procedure update_answer_set_is_latest();
