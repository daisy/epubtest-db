\c :dbname

-- there are a lot of answer sets with null users
-- just set these to something because it interferes with operations

update epubtest."AnswerSets" set "user_id"=207 where "user_id" IS NULL;
update epubtest."Users" set "name"='User' where "id"=207;
