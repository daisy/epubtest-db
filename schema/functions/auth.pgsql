\c epubtest;

create extension if not exists pgcrypto;

-- Function: current_user_id
-- jwt data comes via postgraphile
create or replace function epubtest.current_user_id() returns integer as $$
  select nullif(current_setting('jwt.claims.user_id', true), '')::integer;
$$ language sql stable;


-- Function: authenticate
create or replace function epubtest.authenticate(
    email text,
    password text
)
returns epubtest.jwt_token as $$
declare 
    usr epubtest."Users";
    login epubtest."Logins";
    userrole text;
begin
    select a.* into login
        from epubtest."Logins" as a
        where a.email = authenticate.email;
    if found then 
        if login.password = crypt(authenticate.password, login.password) then
            select a.* into usr
                from epubtest."Users" as a
                where a.login_id = login.id;
            if login.type = 'ADMIN' then
                userrole := 'epubtest_admin_role';
            else
                userrole := 'epubtest_user_role';
            end if;
            if login.active then 
                update epubtest."Logins" 
                    set last_seen = current_timestamp 
                    where id = login.id;
                return (
                    userrole,
                    extract(epoch from now() + interval '7 days'),
                    usr.id
                )::epubtest.jwt_token;
            end if;
        end if;
    end if;
    return null;
end;
$$ language plpgsql VOLATILE strict security definer;

-- Function: create_temporary_token
-- access to this function should be restricted to admins
-- this token will grant user-level access for 1 hour
-- the user must already be in the "Users" table and they also must have an entry
-- in "Logins" with suggested values of {type: 'USER', active: 'f', password: ''}
create or replace function epubtest.create_temporary_token(
    email text
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
        
        if login.type = 'ADMIN' then
            userrole := 'epubtest_admin_role';
        else
            userrole := 'epubtest_user_role';
        end if;
        return (
            userrole,
            extract(epoch from now() + interval '1 hour'),
            usr.id
        )::epubtest.jwt_token;
    else
        return null;
    end if;
end;
$$ language plpgsql VOLATILE strict security definer;

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
            return true;
    else
        return false;
    end if;
    
end;
$$ language plpgsql VOLATILE strict security definer;
