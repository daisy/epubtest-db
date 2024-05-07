\c :dbname
-- this function is no longer needed as the test books have an is_latest column now
-- as well as a function to update the value "update_test_books_is_latest()"
DROP FUNCTION epubtest.get_latest_test_books(lang text);