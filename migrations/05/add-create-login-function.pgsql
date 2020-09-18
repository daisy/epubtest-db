\c :dbname;
set schema 'epubtest';
-- note that we couldn't call this create_login because postgraphile normalizes the naming and so it would be the same as
-- the CreateLogin graphql method, and postgraphile calls out the conflict
create or replace function epubtest.create_new_login(email text, pwd text)
returns int
 as $$
declare
    new_id integer;
    login epubtest."Logins";
begin
    select a.* into login
        from epubtest."Logins" as a
        where a.email = create_new_login.email;
    if not found then 
        insert into epubtest."Logins" ("email", "password", "active")
        values (create_new_login.email, crypt(create_new_login.pwd, gen_salt('bf')), 't')
        returning "id" into new_id;
        return new_id;
    else 
        raise exception 'Email already exists %', create_new_login.email using hint = 'Please check the supplied email address';
    end if;
end;
$$ language plpgsql volatile;
