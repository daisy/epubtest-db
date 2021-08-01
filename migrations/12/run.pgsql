\ir add-table-private-access-tokens.pgsql
\ir add-role-readonly.pgsql
\ir update-function-create-temporary-token.pgsql
\ir update-function-delete-all-data.pgsql

update epubtest."DbInfo" set "value"='12' where "field"='version';
