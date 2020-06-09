-- merge duplicate testing environments

\c :dbname;

set schema 'epubtest';

do $$
declare 
    r epubtest."TestingEnvironments"%rowtype;
    r2 epubtest."TestingEnvironments"%rowtype;
    note text;
    removed_id int;
    processed int[];
    removed int[];
begin
    
    for r in 
        select * from epubtest."TestingEnvironments"
    loop
        raise notice 'Evaluating %', r."id";
        for r2 in 
            select * from epubtest."TestingEnvironments"
            where 
            "reading_system_id"=r."reading_system_id"
            and
            "os_id"=r."os_id"
            and
            "browser_id"=r."browser_id"
            and
            "input"=r."input"
            and
            "is_archived"=r."is_archived"
            and
            "id"!=r."id"
        loop
            processed = array_append(processed, r2."id");
            if not(r."id" = any(processed)) then
                raise notice 'DUPLICATE testenv %', r2."id";

                note = note || '\n\n' || r2."notes";

                update epubtest."AnswerSets"
                set "testing_environment_id"=r."id" where
                "testing_environment_id"=r2."id";

                update epubtest."TestingEnvironments"
                set "notes"=note where
                "id"=r."id";

                update epubtest."AssistiveTechnologiesInTestingEnvironments"
                set "testing_environment_id"=r."id" where
                "testing_environment_id"=r2."id";

                removed = array_append(removed, r2."id");
            end if;
        end loop;
    end loop;

    foreach removed_id in array removed
    loop
        delete from epubtest."TestingEnvironments" where "id"=removed_id;
    end loop;
end $$;