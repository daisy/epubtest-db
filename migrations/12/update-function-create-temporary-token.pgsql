\c :dbname;
set schema 'epubtest';

drop function epubtest.create_temporary_token(text, text);
drop function epubtest.create_temporary_token(text);
-- pass in '' for email to get a readonly_role token
create or replace function epubtest.create_temporary_token(
    email text,
    duration text
)
returns epubtest.jwt_token as $$
declare 
    usr epubtest."Users";
    login epubtest."Logins";
    userrole text;
    userid text;
begin
    if email = '' then
        userrole := 'epubtest_readonly_role';
        userid := 0;
    else 
        select a.* into login
            from epubtest."Logins" as a
            where a.email = create_temporary_token.email;
        
        if found then
            select a.* into usr
                from epubtest."Users" as a
                where a.login_id = login.id;
            
            userrole := 'epubtest_user_role';
            userid := usr.id;
        else
            return null;
        end if;

    end if;

    return (
        userrole,
        extract(epoch from now() + (create_temporary_token.duration)::interval),
        userid
    )::epubtest.jwt_token;
end;
$$ language plpgsql VOLATILE strict security definer;
