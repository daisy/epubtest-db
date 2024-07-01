\c :dbname

-- copy the source answer IDs to the migrated answer created_from_id column
do $$
declare 
    migratedAnswerSetRow epubtest."AnswerSets"%rowtype;
    migratedAnswerRow epubtest."Answers"%rowtype;
    v_notes_are_public boolean;
    v_notes text;
begin
    -- the answers that have no notes and were migrated from other answers
    for migratedAnswerRow in 
        select * from epubtest."Answers" 
            where created_from_id is not null 
            and (notes = '' or notes is null)
    loop
        select notes, notes_are_public into v_notes, v_notes_are_public 
            from epubtest."Answers" where id=migratedAnswerRow."created_from_id";
        
        update epubtest."Answers" set 
            notes=v_notes,
            notes_are_public=v_notes_are_public
            where id=migratedAnswerRow."id";
    end loop;
end $$;

