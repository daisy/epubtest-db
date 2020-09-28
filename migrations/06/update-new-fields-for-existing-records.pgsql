\c :dbname;
set schema 'epubtest';

-- TestingEnvironments.is_public
update epubtest."TestingEnvironments" set "is_public" = TRUE where (select count(*) from epubtest."AnswerSets" where
epubtest."AnswerSets"."testing_environment_id" = "TestingEnvironments"."id" and epubtest."AnswerSets"."is_public" = TRUE) > 0;

-- AnswerSets.is_latest
update epubtest."AnswerSets" set "is_latest" = (select epubtest.is_latest_answer_set("AnswerSets"."id", FALSE));

-- AnswerSets.is_latest_public
update epubtest."AnswerSets" set "is_latest_public" = (select epubtest.is_latest_answer_set("AnswerSets"."id", TRUE));

-- TestBooks.version_major, version_minor, version_patch
update epubtest."TestBooks" set "version_major" = (select regexp_split_to_array(epubtest."TestBooks"."version", E'\\.'))[1]::int;
update epubtest."TestBooks" set "version_minor" = (select regexp_split_to_array(epubtest."TestBooks"."version", E'\\.'))[2]::int;
update epubtest."TestBooks" set "version_patch" = (select regexp_split_to_array(epubtest."TestBooks"."version", E'\\.'))[3]::int;