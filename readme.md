# database schema notes

sql to reset the database. it will then contains all schema, functions, and policies, but no data.

`dropdb`: stop and drop
`epubtest`: create database and add table definitions
`functions/auth`: related to authentication and tokens
`functions/data`: related to data
`policies/public.pgsql`: what public role can do
`policies/user.pgsql`: what user role can do
`policies/admin.pgsql`: what admin role can do

`run-to-resetdb`: execute all of the above in the given order to reset the database. 

## Tables

Quickref: RLS on `Logins`, `Users`, `Softwares`, `TestingEnvironments`, `AnswerSets`, `Answers`

### Logins

* rls: users can change their own password
* in separate table for better postgraphile compatibility


### Users

* rls: users can edit their own details
* Limited to publicly-visible user info (e.g. if the user row is visible, all cols are available to view)

### Langs

* Test books and also the UI (set via cookie maybe?) have language codes

### Topics

* short string topic identifiers used by the test books
* necessary to know that two different books are for the same topic (e.g. french and english versions)

### TestBooks

* `topic_id + lang_id + version` should be unique

### Tests

* `flag`: new or changed compared with previous version of same (`lang_id + topic`) test book
* `test_book_id + test_id` should be unique
* `test_id`: the test ID string (e.g. `basic-010`) 

### Softwares

* rls: public can see only s/w with public results. users can see only that + s/w that they're testing.
* Software includes hardware devices too

### TestingEnvironments

* rls: public can only see testing environments with answer sets that are public. 
* `assistive_technology_id + reading_system_id + os_id + browser_id + device_id` should be unique

### AnswerSets

* rls: public can see if `is_public = true`. else restrict to owner.
* `summary`: long summary to be published on site


### Answers
* rls: public can see if its `AnswerSet.is_public = true`. else restrict to owner.
* `flag`: the `Test` for this `Answer` has been flagged since this was `modified`

## Functions

### current_user_id

Return the current user's ID (internally via `jwt.claims.user_id`);

### authenticate (email, password)

"Volatile" because then it can be a mutation in graphql. Logging in via mutation is better in particular with Apollo, which we used to use and may again use someday, because of issues (perhaps by design) with useLazyQuery. 


### create_temporary_token

"Volatile" as above. 

Give someone enough access to reset their password. This returns a token with user-level credentials, lasting 1 hr.
