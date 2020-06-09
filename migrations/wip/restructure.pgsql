\c :dbname;
-- make new tables

create table if not exists epubtest."OperatingSystems" (
    "id" serial primary key,
    "name" text not null,
    "version" text not null,
    "vendor" text,
    "notes" text
);

create table if not exists epubtest."Browsers" (
    "id" serial primary key,
    "name" text not null,
    "version" text not null,
    "vendor" text,
    "notes" text
);

create table if not exists epubtest."AssistiveTechnologies" (
    "id" serial primary key,
    "name" text not null,
    "version" text not null,
    "vendor" text,
    "notes" text,
    "is_screen_reader" boolean default 'f',
    "is_braille_display" boolean default 'f',
    "is_magnifier" boolean default 'f'
);  

create table if not exists epubtest."ReadingSystems" (
    "id" serial primary key,
    "name" text not null,
    "version" text not null,
    "vendor" text,
    "notes" text,
    "is_self_voicing" boolean default 'f'
);
alter table epubtest."ReadingSystems" enable row level security;

create table if not exists epubtest."AssistiveTechnologiesInTestingEnvironments" (
    "id" serial primary key,
    "testing_environment_id" int not null,
    "assistive_technology_id" int not null,
    foreign key ("testing_environment_id") references epubtest."TestingEnvironments"("id"),
    foreign key ("assistive_technology_id") references epubtest."AssistiveTechnologies"("id")
);

create table if not exists epubtest."AssistiveTechnologiesInAnswerSets" (
    "id" serial primary key,
    "assistive_technology_in_testing_environment_id" int not null,
    "answer_set_id" int not null,
    foreign key ("answer_set_id") references epubtest."AnswerSets"("id"),
    foreign key ("assistive_technology_in_testing_environment_id") 
        references epubtest."AssistiveTechnologiesInTestingEnvironments"("id")
);

-- add columns for new foreign key references on TestingEnvironments
alter table epubtest."TestingEnvironments" add column "new_os_id" int;
alter table epubtest."TestingEnvironments" add constraint fk_os_id 
    foreign key ("new_os_id")
    references epubtest."OperatingSystems"("id");

alter table epubtest."TestingEnvironments" add column "new_reading_system_id" int;
alter table epubtest."TestingEnvironments" add constraint fk_reading_system_id 
    foreign key ("new_reading_system_id")
    references epubtest."ReadingSystems"("id");

alter table epubtest."TestingEnvironments" add column "new_browser_id" int;
alter table epubtest."TestingEnvironments" add constraint fk_browser_id 
    foreign key ("new_browser_id")
    references epubtest."Browsers"("id");

grant usage on sequence epubtest."OperatingSystems_id_seq" to epubtest_admin_role;
grant usage on sequence epubtest."Browsers_id_seq" to epubtest_admin_role;
grant usage on sequence epubtest."AssistiveTechnologies_id_seq" to epubtest_admin_role;
grant usage on sequence epubtest."ReadingSystems_id_seq" to epubtest_admin_role;
grant usage on sequence epubtest."AssistiveTechnologiesInAnswerSets_id_seq" to epubtest_admin_role;
grant usage on sequence epubtest."AssistiveTechnologiesInTestingEnvironments_id_seq" to epubtest_admin_role;

