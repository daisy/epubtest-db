\c :dbname;
set schema 'epubtest';

/*
this is useful for unit testing
remove all rows from data tables except for DbInfo
*/
drop function epubtest.delete_all_data;
create or replace function epubtest.delete_all_data()
returns void as $$
declare
    
begin
    -- these triggers are really slow and there's no reason to run them after every delete on AnswerSets
    perform epubtest.disable_triggers();

    delete from epubtest."Invitations";
    delete from epubtest."Requests";
    delete from epubtest."Answers";
    delete from epubtest."AnswerSets";
    delete from epubtest."Tests";
    delete from epubtest."TestBooks";
    delete from epubtest."TestingEnvironments";
    delete from epubtest."Topics";
    delete from epubtest."Langs";
    delete from epubtest."Users";
    delete from epubtest."Logins";
    delete from epubtest."Softwares";

    -- re-enable the triggers
    perform epubtest.enable_triggers();

end;
$$ language plpgsql volatile;
