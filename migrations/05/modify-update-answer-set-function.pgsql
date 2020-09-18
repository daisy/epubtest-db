\c :dbname;
set schema 'epubtest';

-- rewrite the update answers and answerset function to remove the score parameter
-- since that will be automatically calculated by a trigger function
drop function if exists epubtest.update_answerset_and_answers;
create or replace function epubtest.update_answerset_and_answers(
    answer_set_id integer, 
    summary text,
    answer_ids integer[], 
    answer_values epubtest.answer_value[],
    notes text[],
    notes_are_public boolean[])
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
    set "summary"=update_answerset_and_answers.summary
    where "id"=answer_set_id;

end;
$$ language plpgsql VOLATILE strict;

