\c :dbname
-- add a field to answers that maps to the answer that it was migrated from
alter table epubtest."Answers" add column if not exists "created_from_id" int default null;
alter table epubtest."Answers" add constraint fk_created_from_id
    foreign key ("created_from_id")
    references epubtest."Answers"("id");

-- copy the source answer IDs to the migrated answer created_from_id column
do $$
declare 
    migratedAnswerSetRow epubtest."AnswerSets"%rowtype;
    migratedAnswerRow epubtest."Answers"%rowtype;
    tempAnswerRow epubtest."Answers"%rowtype;
    v_test_id text;
    source_answer_id integer;
    v_notes_are_public boolean;
    v_notes text;
begin
    -- the answer sets that need their answers' notes updated
    for migratedAnswerSetRow in 
        select * from epubtest."AnswerSets" where created_from_id > 0
    loop
        -- raise notice '----';
        -- raise notice 'migrated answer set: %', migratedAnswerSetRow."id";
        -- the answers that need their notes updated
        for migratedAnswerRow in 
            select * from epubtest."Answers" where answer_set_id=migratedAnswerSetRow."id"
        loop
            raise notice '- migrated answer: %', migratedAnswerRow."id";
            -- the test ID string eg file-010
            select test_id into v_test_id from epubtest."Tests" where id=migratedAnswerRow."test_id";
            raise notice '-- test used: %', v_test_id;
            -- the answer that was used as the source for this migrated answer
            select epubtest."Answers".id into source_answer_id
                from epubtest."Answers" 
                join epubtest."Tests" 
                on epubtest."Tests".id = epubtest."Answers".test_id 
                where epubtest."Answers".answer_set_id = migratedAnswerSetRow."created_from_id"
                and epubtest."Tests".test_id=v_test_id;
            
            -- raise notice '-- source answer: %', source_answer_id;
            -- raise notice '-- notes were *%*', migratedAnswerRow."notes";

            if (source_answer_id > 0 and source_answer_id != NULL ) then
                -- select notes, notes_are_public 
                --     into v_notes, v_notes_are_public 
                --     from epubtest."Answers"
                --     where epubtest."Answers".id = source_answer_id;
                
                update epubtest."Answers" 
                    set created_from_id=source_answer_id
                    where epubtest."Answers".id = migratedAnswerRow."id";
            end if;
        end loop;
    end loop;
end $$;

-- update epubtest."Answers" a2 set notes = (select a1.notes from epubtest."Answers" a1 
-- inner join epubtest."Answers" a2 on a1.id = a2.created_from_id and a2.notes != '' and a2.notes != NULL)