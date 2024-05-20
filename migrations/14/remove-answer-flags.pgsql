\c :dbname

-- there are a handful of flagged answers
-- but these flags aren't meaningful anymore and just get in the way
-- of the new test book versioning/flagging system
-- the corresponding IDs have been recorded

update epubtest."Answers" set "flag"=FALSE;

