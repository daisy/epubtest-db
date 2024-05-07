\c :dbname
-- this column is not as useful as checking answer_set's answers for flags
alter table epubtest."AnswerSets" drop column "flag" cascade;