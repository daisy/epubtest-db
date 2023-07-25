\c :dbname;
drop role if exists epubtest_admin_role;
create role epubtest_admin_role;

drop role if exists epubtest_app_role;
create role epubtest_app_role with LOGIN password :'appRolePassword';

drop role if exists epubtest_user_role;
create role epubtest_user_role;

drop role if exists epubtest_public_role;
create role epubtest_public_role;

drop role if exists epubtest_readonly_role;
create role epubtest_readonly_role;
