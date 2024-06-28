\c :dbname
-- make the notes field consistent
update epubtest."Answers" set notes='' where notes='null';
update epubtest."Answers" set notes='' where trim(notes)='';
