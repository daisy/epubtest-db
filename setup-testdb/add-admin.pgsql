\c :dbname;
do $$ 
declare
    new_id integer;
begin 
   INSERT into epubtest."Logins"(
    "email",
    "password",
    "type",
    "active"
)
VALUES (
    'admin@example.com',
    crypt('password', gen_salt('bf')),
    'ADMIN',
    TRUE
)
RETURNING "id" INTO new_id;

INSERT INTO epubtest."Users"(
    "login_id",
    "name"
)
VALUES (
    new_id,
    'Administrator'
);
end $$;
