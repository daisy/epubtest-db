\c :dbname;
set schema 'epubtest';

select epubtest.run_answer_set_trigger_operations();

-- TestBooks.version_major, version_minor, version_patch
update epubtest."TestBooks" set "version_major" = (select regexp_split_to_array(epubtest."TestBooks"."version", E'\\.'))[1]::int;
update epubtest."TestBooks" set "version_minor" = (select regexp_split_to_array(epubtest."TestBooks"."version", E'\\.'))[2]::int;
update epubtest."TestBooks" set "version_patch" = (select regexp_split_to_array(epubtest."TestBooks"."version", E'\\.'))[3]::int;