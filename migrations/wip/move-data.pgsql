\c :dbname;

do $$
declare 
    r epubtest."Softwares"%rowtype;
    tenv epubtest."TestingEnvironments"%rowtype;
    aset epubtest."AnswerSets"%rowtype;
begin

    -- move the OSes over
    for r in 
        select * from epubtest."Softwares" where "type"='OS'
    loop
        insert into epubtest."OperatingSystems"("name", "version", "vendor")
        values(r."name", r."version", r."vendor");

        update epubtest."TestingEnvironments" set
            "new_os_id"=(select currval('"epubtest"."OperatingSystems_id_seq"'))
            where "TestingEnvironments"."os_id"=r."id";
    end loop;

    -- move the Browsers over
    for r in 
        select * from epubtest."Softwares" where "type"='BROWSER'
    loop
        insert into epubtest."Browsers"("name", "version", "vendor")
        values(r."name", r."version", r."vendor");

        update epubtest."TestingEnvironments" set
            "new_browser_id"=(select currval('"epubtest"."Browsers_id_seq"'))
            where "TestingEnvironments"."browser_id"=r."id";
    end loop;

    -- move the reading systems over
    for r in 
        select * from epubtest."Softwares" where "type"='READING_SYSTEM'
    loop
        insert into epubtest."ReadingSystems"("name", "version", "vendor")
        values(r."name", r."version", r."vendor");

        update epubtest."TestingEnvironments" set
            "new_reading_system_id"=(select currval('"epubtest"."ReadingSystems_id_seq"'))
            where "TestingEnvironments"."reading_system_id"=r."id";
    end loop;

    -- move the ATs over
    for r in 
        select * from epubtest."Softwares" where 
        "type"='ASSISTIVE_TECHNOLOGY' 
        or
        "type"='DEVICE'
    loop
        if r."name" != '' then
            raise notice 'type %', r."type";
            -- at this point, all the ATs are screen readers
            if r."type" = 'ASSISTIVE_TECHNOLOGY' then
                raise notice 'adding AT (screen reader)';
                insert into epubtest."AssistiveTechnologies"("name", "version", "vendor", 
                    "is_screen_reader")
                values(
                    r."name", 
                    r."version", 
                    r."vendor",
                    't'
                );
            else
                raise notice 'adding AT - braille';
                -- at this point, all the devices are braille displays
                insert into epubtest."AssistiveTechnologies"("name", "version", "vendor", 
                    "is_braille_display")
                values(
                    r."name", 
                    r."version", 
                    r."vendor",
                    't'
                );
            end if;

            for tenv in 
                select * from epubtest."TestingEnvironments"
                where "assistive_technology_id"=r."id"
                or
                "device_id"=r."id"
            loop
                insert into epubtest."AssistiveTechnologiesInTestingEnvironments" (
                    "assistive_technology_id", "testing_environment_id"
                )
                values (
                    (select currval('"epubtest"."AssistiveTechnologies_id_seq"')),
                    tenv."id"
                );

                for aset in 
                    select * from epubtest."AnswerSets"
                    where "testing_environment_id"=tenv."id"
                loop
                    insert into epubtest."AssistiveTechnologiesInAnswerSets" (
                        "assistive_technology_in_testing_environment_id",
                        "answer_set_id"
                    )
                    values (
                        (select currval('"epubtest"."AssistiveTechnologiesInTestingEnvironments_id_seq"')),
                        aset."id"
                    );
                end loop;

            end loop;

            
        end if;
    end loop;


    alter table epubtest."TestingEnvironments" drop column "os_id" cascade;
    alter table epubtest."TestingEnvironments" drop column "browser_id" cascade;
    alter table epubtest."TestingEnvironments" drop column "reading_system_id" cascade;
    alter table epubtest."TestingEnvironments" drop column "device_id" cascade;

    alter table epubtest."TestingEnvironments" rename column "new_os_id" to "os_id";
    alter table epubtest."TestingEnvironments" rename column "new_browser_id" to "browser_id";
    alter table epubtest."TestingEnvironments" rename column "new_reading_system_id" to "reading_system_id";

    alter table epubtest."TestingEnvironments" drop column "assistive_technology_id" cascade;
    alter table epubtest."TestingEnvironments" drop column "tested_with_braille";
    alter table epubtest."TestingEnvironments" drop column "tested_with_screenreader";

    alter table epubtest."TestingEnvironments" alter column "os_id" set not null;
    alter table epubtest."TestingEnvironments" alter column "reading_system_id" set not null;

    drop table epubtest."Softwares";

    -- TODO add screen magnifiers manually
end $$;