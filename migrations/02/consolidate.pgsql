\c :dbname;
set schema 'epubtest';

alter table epubtest."TestingEnvironments" alter column "assistive_technology_id" drop not null;

do $$
declare 
    r epubtest."Softwares"%rowtype;
    r2 epubtest."Softwares"%rowtype;
    tenv epubtest."TestingEnvironments"%rowtype;
    note text;
    removed_id int;
    processed int[];
    removed int[];
begin
    -- add notes column to testing environments
    raise notice 'Add column notes to TestingEnvironments';
    alter table epubtest."TestingEnvironments" add column if not exists "notes" text;

    -- clean up notes
    raise notice 'Clearing undefined notes from Softwares';
    for r in 
        select * from epubtest."Softwares"
    loop
        if r."notes" = 'undefined' or trim(both from r."notes") = '' then
            update epubtest."Softwares"
            set "notes" = '' where "id"=r."id";
        end if;
    end loop;

    -- move notes to testing environment
    raise notice 'Moving Softwares notes to TestingEnvironments';
    for tenv in 
        select * from epubtest."TestingEnvironments"
    loop
        note = '';
        if (select "notes" from epubtest."Softwares" 
            where "Softwares"."id" = tenv."reading_system_id") != '' then
            note = note || 'RS notes: ' || (select "notes" from epubtest."Softwares" 
            where "id" = tenv."reading_system_id") || '\n';
        end if;
        if (select "notes" from epubtest."Softwares" 
            where "Softwares"."id" = tenv."os_id") != '' then
            note = note || 'OS notes: ' || (select "notes" from epubtest."Softwares" 
            where "Softwares"."id" = tenv."os_id") || '\n';
        end if;

        update epubtest."TestingEnvironments"
        set "notes"=note 
        where "TestingEnvironments"."id"=tenv."id";
    end loop;

    -- remove the notes from software
    update epubtest."Softwares" set "notes" = '';
    
    for r in 
        select * from epubtest."Softwares"
    loop
        for r2 in 
            select * from epubtest."Softwares"
            where 
            "name"=r."name"
            and
            "version"=r."version"
            and
            "vendor"=r."vendor"
            and
            "id"!=r."id"
        loop
            processed = array_append(processed, r2."id");

            if r."type" = 'READING_SYSTEM' and not(r."id" = any(processed)) then
                raise notice 'Set reading_system_id % to %', r2."id", r."id";
                update epubtest."TestingEnvironments"
                set "reading_system_id"=r."id" where "reading_system_id"=r2."id";
                removed = array_append(removed, r2."id");
            elsif r."type" = 'ASSISTIVE_TECHNOLOGY' and not(r."id" = any(processed)) then
                raise notice 'Set assistive_technology_id % to %', r2."id", r."id";
                update epubtest."TestingEnvironments"
                set "assistive_technology_id"=r."id" where "assistive_technology_id"=r2."id";
                removed = array_append(removed, r2."id");
            elsif r."type" = 'OS' and not(r."id" = any(processed)) then
                raise notice 'Set os_id % to %', r2."id", r."id";
                update epubtest."TestingEnvironments"
                set "os_id"=r."id" where "os_id"=r2."id";
                removed = array_append(removed, r2."id");
            elsif r."type" = 'BROWSER' and not(r."id" = any(processed)) then
                raise notice 'Set browser_id % to %', r2."id", r."id";
                update epubtest."TestingEnvironments"
                set "browser_id"=r."id" where "browser_id"=r2."id";
                removed = array_append(removed, r2."id");
            elsif r."type" = 'DEVICE' and not(r."id" = any(processed)) then
                raise notice 'Set device_id % to %', r2."id", r."id";
                update epubtest."TestingEnvironments"
                set "device_id"=r."id" where "device_id"=r2."id";
                removed = array_append(removed, r2."id");
            end if;
        end loop;
    end loop;

    foreach removed_id in array removed
    loop
        delete from epubtest."Softwares" where "id"=removed_id;
    end loop;

    
    
end $$;