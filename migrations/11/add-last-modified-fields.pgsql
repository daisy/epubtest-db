\c :dbname;
set schema 'epubtest';

-- when was the answer modified
alter table epubtest."Answers" add column last_modified timestamptz;
-- when was the answer set modified; includes when any of its answers were modified (see triggers)
alter table epubtest."AnswerSets" add column last_modified timestamptz;
