\ir add-create-login-function.pgsql
\ir modify-answer-sets-make-user-optional.pgsql
\ir modify-testbooks-add-flags.pgsql
\ir drop-topic-type.pgsql
\ir modify-get-latest-test-books-function.pgsql
\ir add-notes-to-testing-environment.pgsql
\ir modify-update-answer-set-function.pgsql
\ir add-trigger-for-score.pgsql
update epubtest."DbInfo" set "value"='05' where "field"='version';