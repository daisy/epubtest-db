\ir modify-compare-versions-function.pgsql
\ir modify-is-latest-answer-set-function.pgsql
\ir add-is-public-field.pgsql
\ir add-is-latest-fields.pgsql
\ir update-new-fields-for-existing-records.pgsql

update epubtest."DbInfo" set "value"='06' where "field"='version';



