\c :dbname;

-- pg dump exports this function incorrectly so we have to redeclare it here
-- the workflow that this file is a part of includes restoring from pg_dump
drop function epubtest.compare_versions;

CREATE FUNCTION epubtest.compare_versions(v1 text, v2 text, ignorepatch boolean DEFAULT false) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$
declare
    v1arr int[];
    v2arr int[];
begin
    select into v1arr regexp_split_to_array(v1, E'\\.');
    select into v2arr regexp_split_to_array(v2, E'\\.');
    if v1arr[1] = v2arr[1] then
        if v1arr[2] = v2arr[2] then
            if ignorePatch then
                return 0;
            else
                if v1arr[3] = v2arr[3] then
                    return 0;
                else
                    if v1arr[3] > v2arr[3] then
                        return 1;
                    else /*v1arr[3] > v2arr[3]*/
                        return -1;
                    end if;
                end if;
            end if;
        else
            if v1arr[2] > v2arr[2] then
                return 1;
            else /*v1arr[2] > v2arr[2]*/
                return -1;
            end if;
        end if;
    else
        if v1arr[1] > v2arr[1] then
            return 1;
        else /*v1arr[1] < v2arr[1] */
            return -1;
        end if;
    end if;
end;
$$;
