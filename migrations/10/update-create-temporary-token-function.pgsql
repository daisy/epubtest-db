\c :dbname;
set schema 'epubtest';

drop function epubtest.create_temporary_token(text, text);
drop function epubtest.create_temporary_token(text);
create or replace function epubtest.create_temporary_token(
    email text,
    duration text
)
returns epubtest.jwt_token as $$
declare 
    usr epubtest."Users";
    login epubtest."Logins";
    userrole text;
begin
    select a.* into login
        from epubtest."Logins" as a
        where a.email = create_temporary_token.email;
    
    if found then
        select a.* into usr
            from epubtest."Users" as a
            where a.login_id = login.id;
        
        userrole := 'epubtest_user_role';
        return (
            userrole,
            extract(epoch from now() + (create_temporary_token.duration)::interval),
            usr.id
        )::epubtest.jwt_token;
    else
        return null;
    end if;
end;
$$ language plpgsql VOLATILE strict security definer;
