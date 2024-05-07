
\c :dbname;
set schema 'epubtest';
-- this function gets mangled in dump/restore operations
-- so this fix is required (regexp gets dumped as E'\.' not E'\\.')
DROP TRIGGER update_version_columns_trigger ON epubtest."TestBooks";

DROP FUNCTION epubtest.update_version_columns();

CREATE FUNCTION epubtest.update_version_columns() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
    begin
        update epubtest."TestBooks" set "version_major" = (select regexp_split_to_array(epubtest."TestBooks"."version", E'\\.'))[1]::int 
            where epubtest."TestBooks"."id" = new."id";
        update epubtest."TestBooks" set "version_minor" = (select regexp_split_to_array(epubtest."TestBooks"."version", E'\\.'))[2]::int 
            where epubtest."TestBooks"."id" = new."id";
        update epubtest."TestBooks" set "version_patch" = (select regexp_split_to_array(epubtest."TestBooks"."version", E'\\.'))[3]::int 
            where epubtest."TestBooks"."id" = new."id";
        return new;
    end;
$$;


ALTER FUNCTION epubtest.update_version_columns() OWNER TO postgres;

CREATE TRIGGER update_version_columns_trigger AFTER INSERT OR UPDATE OF version ON epubtest."TestBooks" FOR EACH ROW EXECUTE PROCEDURE epubtest.update_version_columns();
