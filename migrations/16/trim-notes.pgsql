-- migration 15 includes this but it's unclear if it ran ok so 
-- it doesn't hurt to repeat it
\c :dbname
-- make the notes field consistent
update epubtest."Answers" set notes='' where notes='null';
update epubtest."Answers" set notes='' where trim(notes)='';
