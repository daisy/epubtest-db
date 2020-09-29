\ir add-version-breakout-test-books.pgsql
\ir modify-compare-versions-function.pgsql
\ir modify-is-latest-answer-set-function.pgsql
\ir modify-is-latest-test-book-function.pgsql
\ir add-is-public-field.pgsql
\ir add-is-latest-fields.pgsql
\ir add-run-answer-set-trigger-operations-function.pgsql
\ir update-new-fields-for-existing-records.pgsql
\ir grant-trigger-to-admin.pgsql
\ir add-delete-test-book-and-answer-sets-function.pgsql
\ir add-delete-all-data-function.pgsql
update epubtest."DbInfo" set "value"='06' where "field"='version';



