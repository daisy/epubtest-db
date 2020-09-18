\c :dbname;
set schema 'epubtest';

alter table epubtest."AnswerSets" alter column "user_id" drop not null;
