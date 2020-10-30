\c :dbname;
set schema 'epubtest';

comment on constraint "Tests_test_book_id_fkey" on epubtest."Tests" is
  E'@foreignFieldName tests';

comment on constraint "Answers_answer_set_id_fkey" on epubtest."Answers" is
  E'@foreignFieldName answers';

comment on constraint "AnswerSets_testing_environment_id_fkey" on epubtest."AnswerSets" is
  E'@foreignFieldName answerSets';

