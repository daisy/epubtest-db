\c :dbname;
set schema 'epubtest';

-- Function: set password
create or replace function epubtest.set_password(
    user_id integer,
    new_password text
)
returns boolean as $$
declare 
    usr epubtest."Users";
    login epubtest."Logins";
begin
    select a.* into usr
        from epubtest."Users" as a
        where a.id = user_id;
    
    if found then
        select a.* into login
            from epubtest."Logins" as a
            where a.id = usr.login_id;

            update epubtest."Logins" set password=crypt(new_password, gen_salt('bf'))
            where epubtest."Logins"."id" = login.id;

            -- also set the login as 'active'
            update epubtest."Logins" set active=true 
            where epubtest."Logins"."id" = login.id;
            
            return true;
    else
        return false;
    end if;
    
end;
$$ language plpgsql VOLATILE strict security definer;
