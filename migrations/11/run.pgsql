\ir add-is-migration-field.pgsql
\ir update-users-table-set-is-migration.pgsql
\ir add-last-modified-fields.pgsql
\ir add-last-modified-triggers.pgsql
\ir update-enable-disable-triggers.pgsql
update epubtest."DbInfo" set "value"='11' where "field"='version';
