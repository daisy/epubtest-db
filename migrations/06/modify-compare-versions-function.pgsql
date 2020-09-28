\c :dbname;
set schema 'epubtest';
-- with the new version schema (separate columns for maj min patch), a comparison function isn't necessary
drop function epubtest.compare_versions;

-- remove console output from this function
/*
versions must be "1.2.3" MAJ.MIN.PATCH format

v1 < v2 ? -1
v1 = v2 ? 0 
v1 > v2 ? 1

ignorePatch = ignore patch version number
*/
-- create or replace function epubtest.compare_versions(
--     v1 text, 
--     v2 text,
--     ignorePatch boolean default false
-- )
-- returns integer as $$
-- declare
--     v1arr int[];
--     v2arr int[];
-- begin
--     select into v1arr regexp_split_to_array(v1, E'\\.');
--     select into v2arr regexp_split_to_array(v2, E'\\.');
--     if v1arr[1] = v2arr[1] then
--         if v1arr[2] = v2arr[2] then
--             if ignorePatch then
--                 return 0;
--             else
--                 if v1arr[3] = v2arr[3] then
--                     return 0;
--                 else
--                     if v1arr[3] > v2arr[3] then
--                         return 1;
--                     else /*v1arr[3] > v2arr[3]*/
--                         return -1;
--                     end if;
--                 end if;
--             end if;
--         else
--             if v1arr[2] > v2arr[2] then
--                 return 1;
--             else /*v1arr[2] > v2arr[2]*/
--                 return -1;
--             end if;
--         end if;
--     else
--         if v1arr[1] > v2arr[1] then
--             return 1;
--         else /*v1arr[1] < v2arr[1] */
--             return -1;
--         end if;
--     end if;
-- end;
-- $$ language plpgsql stable;

