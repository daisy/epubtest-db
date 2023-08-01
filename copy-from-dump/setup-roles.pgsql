-- run this after the db has been created */
-- from initial-schema/policies/app.pgsql */
grant execute on all functions in schema epubtest to epubtest_app_role;
grant all privileges on database :dbname to epubtest_app_role;
grant all privileges on all tables in schema epubtest to epubtest_app_role;

-- from initial-schema/policies/public.pgsql
alter default privileges revoke execute on functions from epubtest_public_role;
grant epubtest_public_role to epubtest_app_role;

-- from initial-schema/policies/user.pgsql
grant epubtest_public_role to epubtest_user_role;
grant epubtest_user_role to epubtest_app_role;

-- from initial-schema/policies/admin.pgsql
grant epubtest_admin_role to epubtest_app_role;
