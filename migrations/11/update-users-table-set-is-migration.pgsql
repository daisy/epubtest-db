\c :dbname;
set schema 'epubtest';

-- at the moment of running this operation, all the inactive accounts were migrations
-- because an inactive account could also occur temporarily as part of the invite/cancel invite process
-- we want to mark the migrated accounts explicitly
update epubtest."Users" set "is_migration" = not epubtest."Logins"."active" 
from epubtest."Logins" 
where epubtest."Logins"."id" = epubtest."Users"."login_id";
