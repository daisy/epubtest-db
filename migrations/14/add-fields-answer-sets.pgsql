\c :dbname
alter table epubtest."AnswerSets" add column if not exists "created" timestamptz default now();
alter table epubtest."AnswerSets" add column if not exists "created_from_id" int default null;
-- in the case of automatic upgrades, what answer set was this one created from?
alter table epubtest."AnswerSets" add constraint fk_created_from_id
    foreign key ("created_from_id")
    references epubtest."AnswerSets"("id");
