\c :dbname

update epubtest."AnswerSets" set is_public=false where test_book_id=11 and is_public=true;