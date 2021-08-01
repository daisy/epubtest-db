\c :dbname;
set schema 'epubtest';

create table if not exists epubtest."PrivateAccessTokens" (
    "id" serial primary key,
    "key" text not null,
    "token" text not null,
    "date_created" timestamptz default current_timestamp,
    "answer_set_id" integer not null,
    foreign key("answer_set_id") references epubtest."AnswerSets"("id")
);
comment on constraint "PrivateAccessTokens_answer_set_id_fkey" on epubtest."PrivateAccessTokens" is
    E'@foreignFieldName privateAccessTokens';

grant select, update, insert, delete on epubtest."PrivateAccessTokens" to epubtest_app_role;
grant select, update, insert, delete on epubtest."PrivateAccessTokens" to epubtest_admin_role;
grant select, update, insert, delete on epubtest."PrivateAccessTokens" to epubtest_user_role;
grant select on epubtest."PrivateAccessTokens" to epubtest_public_role;

grant usage on sequence epubtest."PrivateAccessTokens_id_seq" to epubtest_admin_role;
grant usage on sequence epubtest."PrivateAccessTokens_id_seq" to epubtest_user_role;