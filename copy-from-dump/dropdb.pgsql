select pg_terminate_backend(pg_stat_activity.pid)
from pg_stat_activity
where pg_stat_activity.datname = :'dbname'
  and pid <> pg_backend_pid();

drop database if exists :dbname;

drop role if exists epubtest_admin_role;
drop role if exists epubtest_app_role;
drop role if exists epubtest_user_role;
drop role if exists epubtest_user_role;
drop role if exists epubtest_public_role;
drop role if exists epubtest_readonly_role;

drop schema epubtest cascade;