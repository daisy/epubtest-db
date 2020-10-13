# database notes


## Useful scripts

* `clone-db`: make a copy of the database from the server (connection details configured in `.env`)
    * Note that this only works on localhost
* `migrations`: apply a migration

## Tables

Quickref: RLS on `Logins`, `Users`, `Softwares`, `TestingEnvironments`, `AnswerSets`, `Answers`

### Answers
* rls: public can see if its `AnswerSet.is_public = true`. else restrict to owner.
* `flag`: the `Test` for this `Answer` has been flagged since this was `modified`

### AnswerSets

* rls: public can see if `is_public = true`. else restrict to owner.
* `summary`: long summary to be published on site

### DbInfo

* metadata about the database
* keywords: `version` (corresponds to the number of the most recent group of migrations that were run)

### Invitations
* rls: Users can see their own invitation(s). Public can't see anything. 
* Users get invitations to use the website

### Langs

* Test books and also the UI (set via cookie maybe?) have language codes

### Logins

* rls: users can change their own password
* in separate table for better postgraphile compatibility

### Requests

* Users submit requests to publish their result sets

### Softwares

* rls: public can see only s/w with public results. users can see only that + s/w that they're testing.
* Software includes hardware devices too

### TestBooks

* `topic_id + lang_id + version` should be unique

### TestingEnvironments

* rls: public can only see testing environments with answer sets that are public. 
* `assistive_technology_id + reading_system_id + os_id + browser_id + device_id` should be unique

### Tests

* `flag`: new or changed compared with previous version of same (`lang_id + topic`) test book
* `test_book_id + test_id` should be unique
* `test_id`: the test ID string (e.g. `basic-010`) 

### Topics

* short string topic identifiers used by the test books
* necessary to know that two different books are for the same topic (e.g. french and english versions)

### Users

* rls: users can edit their own details
* Limited to publicly-visible user info (e.g. if the user row is visible, all cols are available to view)

## PostgreSQL functions

### current_user_id

Return the current user's ID (internally via `jwt.claims.user_id`);

### authenticate (email, password)

"Volatile" because then it can be a mutation in graphql. Logging in via mutation is better in particular with Apollo, which we used to use and may again use someday, because of issues (perhaps by design) with useLazyQuery. 


### create_temporary_token

"Volatile" as above. 

Give someone enough access to reset their password. This returns a token with user-level credentials, lasting 1 hr.

### compare_versions

### current_user_id

### get_active_users

### get_archived_testing_environments

### get_latest_test_books

### get_published_testing_environments

### get_topic_for_answerset

### get_user_testing_environments

### is_latest_answer_set

### is_latest_test_book

### remove_user_and_activity

### set_password

### update_answerset_and_answers
