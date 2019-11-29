/*
Tables:
  Logins (*)
  Users (*)
  Langs
  Topics
  TestBooks
  Tests
  Softwares
  TestingEnvironments
  AnswerSets (*)
  Answers (*)
  Requests
  * = RLS
*/

create database epubtest;

\c epubtest;

create schema epubtest;

create type epubtest.user_type as enum('USER', 'ADMIN');
create table epubtest."Logins" (
    "id" serial primary key,
    "email" text not null,
    "password" text not null,
    "last_seen" timestamptz,
    "active" boolean default 'f',
    "type" epubtest.user_type default 'USER'
);
comment on table epubtest."Logins" is 'User login information';
alter table epubtest."Logins" enable row level security;

create table epubtest."Users" (
  "id" serial primary key,
  "login_id" integer not null,
  "name" text,
  "organization" text,
  "website" text,
  "include_credit" boolean default 'f',
  "credit_as" text,
  foreign key ("login_id") references epubtest."Logins"("id")
);
comment on table epubtest."Users" is 'User profile information';
alter table epubtest."Users" enable row level security;

create table epubtest."Langs" (
  "id" text primary key,
  "label" text not null
);
comment on table epubtest."Langs" is 'Language codes and labels';

create type epubtest.topic_type as enum ('ESSENTIAL', 'ADVANCED');

create table epubtest."Topics" (
  "id" text primary key,
  "order" integer not null,
  "type" epubtest.topic_type not null
);

comment on table epubtest."Topics" is 'Topics used in test books, identified by a short string';

create table epubtest."TestBooks" (
  "id" serial primary key,
  "epub_id" text,
  "topic_id" text not null,
  "lang_id" text not null,
  "version" text not null,
  "title" text not null,
  "description" text,
  "ingested" timestamptz not null,
  "filename" text not null,
  foreign key ("topic_id") references epubtest."Topics"("id"),
  foreign key ("lang_id") references epubtest."Langs"("id")
);

comment on table epubtest."TestBooks" is 'Parsed representations of EPUBs used for testing';

create table epubtest."Tests" (
  "id" serial primary key,
  "test_id" text not null,
  "test_book_id" integer not null,
  "name" text not null,
  "description" text,
  "xhtml" text not null,
  "order" integer not null,
  "flag" boolean default 'f',
  foreign key ("test_book_id") references epubtest."TestBooks"("id")
);

comment on table epubtest."Tests" is 'Parsed representations of tests from EPUBs';

create type epubtest.software_type as enum ('READING_SYSTEM', 'ASSISTIVE_TECHNOLOGY', 'BROWSER', 'OS', 'DEVICE');

create table epubtest."Softwares" (
  "id" serial primary key,
  "name" text not null,
  "version" text,
  "vendor" text,
  "type" epubtest.software_type not null,
  "notes" text
);
comment on table epubtest."Softwares" is 'All types of software and devices used for testing';
alter table epubtest."Softwares" enable row level security;

create type epubtest.input_type as enum('KEYBOARD', 'MOUSE', 'TOUCH');

create table epubtest."TestingEnvironments" (
  "id" serial primary key,
  "assistive_technology_id" integer not null,
  "reading_system_id" integer not null,
  "os_id" integer not null,
  "browser_id" integer,
  "device_id" integer,
  "input" epubtest.input_type not null,
  "tested_with_braille" boolean default 'f',
  "tested_with_screenreader" boolean default 'f',
  "is_archived" boolean default 'f',
  foreign key ("assistive_technology_id") references epubtest."Softwares"("id"),
  foreign key ("reading_system_id") references epubtest."Softwares"("id"),
  foreign key ("os_id") references epubtest."Softwares"("id"),
  foreign key ("browser_id") references epubtest."Softwares"("id"),
  foreign key ("device_id") references epubtest."Softwares"("id")
);
comment on table epubtest."TestingEnvironments" is 'Represents the stack of software used in the reader''s environment';
alter table epubtest."TestingEnvironments" enable row level security;

-- notes and short_summary are legacy fields
-- flag is for when the test book becomes outdated
-- score should get updated upon update
create table epubtest."AnswerSets" (
  "id" serial primary key,
  "test_book_id" integer not null,
  "user_id" integer not null,
  "is_public" boolean default 'f' not null,
  "summary" text,
  "notes" text,
  "short_summary" text,
  "testing_environment_id" integer not null,
  "score" numeric not null,
  "flag" boolean default 'f' not null,
  foreign key ("test_book_id") references epubtest."TestBooks"("id"),
  foreign key ("testing_environment_id") references epubtest."TestingEnvironments"("id"),
  foreign key ("user_id") references epubtest."Users"("id")

);
comment on table epubtest."AnswerSets" is 'Answers for a single testing environment for a single test book, with notes about the process';
alter table epubtest."AnswerSets" enable row level security;

create type epubtest.answer_value as enum('PASS', 'FAIL', 'NA', 'NOANSWER');
create table epubtest."Answers" (
  "id" serial primary key,
  "notes" text,
  "notes_are_public" boolean default 'f' not null,
  "test_id" integer not null,
  "value" epubtest.answer_value default 'NOANSWER' not null,
  "flag" boolean default 'f' not null,
  "answer_set_id" integer not null,
  foreign key ("answer_set_id") references epubtest."AnswerSets"("id"),
  foreign key ("test_id") references epubtest."Tests"("id")
);
comment on table epubtest."Answers" is 'Answer for an individual test. Belongs to an AnswerSet.';
alter table epubtest."Answers" enable row level security;

-- leaving this open to add more types in the future
create type epubtest.request_type as enum('PUBLISH');

create table epubtest."Requests" (
  "id" serial primary key,
  "type" epubtest.request_type not null,
  "answer_set_id" integer not null,
  "created" timestamptz default current_timestamp,
  foreign key ("answer_set_id") references epubtest."AnswerSets"("id")
);

/*
  JWT format
*/
create type epubtest.jwt_token as (
  role text,
  expires integer,
  user_id integer
);

