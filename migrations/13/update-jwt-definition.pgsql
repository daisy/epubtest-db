\c :dbname;
set schema 'epubtest';

/*
  JWT format
*/
alter type epubtest.jwt_token RENAME ATTRIBUTE expires TO exp;