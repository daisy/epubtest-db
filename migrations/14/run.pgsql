
\ir fix_function.pgsql
\ir new_function_latest_test_books.pgsql
\ir drop_function_get_latest_test_books.pgsql
\ir drop_column_answerset_flag.pgsql
\ir add-download-url-field-test-books.pgsql
\ir remove-answer-flags.pgsql
\ir add-fields-answer-sets.pgsql
update epubtest."DbInfo" set "value"='14' where "field"='version';
