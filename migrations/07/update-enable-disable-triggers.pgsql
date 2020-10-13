\c :dbname;
set schema 'epubtest';

-- non-owner roles cannot disable triggers
-- but we can provide a function to do so
-- and give the role access to that function

-- disable triggers on answer sets
drop function disable_triggers;
-- put it in epubtest schema this time :) 
create or replace function epubtest.disable_triggers() 
returns void
language SQL 
as $$
    alter table epubtest."AnswerSets" disable trigger answer_set_is_latest_trigger;
    alter table epubtest."AnswerSets" disable trigger testing_environment_is_public_trigger;
    alter table epubtest."Answers" disable trigger answer_set_is_tested_trigger;
$$ security definer;

-- enable triggers on answer sets
drop function enable_triggers;
-- put it in epubtest schema this time :) 
create or replace function epubtest.enable_triggers() 
returns void
language SQL 
as $$
    alter table epubtest."AnswerSets" enable trigger answer_set_is_latest_trigger;
    alter table epubtest."AnswerSets" enable trigger testing_environment_is_public_trigger;
    alter table epubtest."Answers" enable trigger answer_set_is_tested_trigger;
$$ security definer;

-- give permission
grant execute on function disable_triggers() to epubtest_admin_role;
grant execute on function enable_triggers() to epubtest_admin_role;