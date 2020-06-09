\c :dbname;

\echo 'Logins';
insert into epubtest."Logins"("id", "email", "password", "type") values (101, $$admin@example.com$$, $$$$, $$ADMIN$$);
insert into epubtest."Logins"("id", "email", "password", "type") values (102, $$one@example.com$$, $$$$, $$USER$$);
insert into epubtest."Logins"("id", "email", "password", "type") values (103, $$two@example.com$$, $$$$, $$USER$$);
insert into epubtest."Logins"("id", "email", "password", "type") values (104, $$three@example.com$$, $$$$, $$ADMIN$$);

\echo 'Users';
insert into epubtest."Users"("id", "login_id", "name") values (1, 101, $$Admin$$);
insert into epubtest."Users"("id", "login_id", "name") values (2, 102, $$User One$$);
insert into epubtest."Users"("id", "login_id", "name") values (3, 103, $$User TWo$$);
insert into epubtest."Users"("id", "login_id", "name") values (4, 104, $$User Three$$);

-- set passwords
select epubtest.set_password(1, 'password');
select epubtest.set_password(2, 'password');
select epubtest.set_password(3, 'password');
select epubtest.set_password(4, 'password');