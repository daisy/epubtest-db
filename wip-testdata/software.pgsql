\c :dbname;

\echo 'Softwares';
-- AT
insert into epubtest."Softwares"("name", "id", "type", "version", "notes") values ($$Talkback$$, 1, $$ASSISTIVE_TECHNOLOGY$$, $$3.5.2$$, $$$$);
insert into epubtest."Softwares"("name", "id", "type", "version", "notes") values ($$VoiceOver$$, 4, $$ASSISTIVE_TECHNOLOGY$$, $$undefined$$, $$undefined$$);
insert into epubtest."Softwares"("name", "id", "type", "version", "notes") values ($$JAWS for Windows$$, 5, $$ASSISTIVE_TECHNOLOGY$$, $$15$$, $$undefined$$);
insert into epubtest."Softwares"("name", "id", "type", "version", "notes") values ($$NVDA$$, 6, $$ASSISTIVE_TECHNOLOGY$$, $$2014.2$$, $$undefined$$);

-- RS
insert into epubtest."Softwares"("name", "id", "type", "version", "notes") values ($$Kobo$$, 101, $$READING_SYSTEM$$, $$7.3$$, $$iOS app$$);
insert into epubtest."Softwares"("name", "id", "type", "version", "notes") values ($$Gitden Reader$$, 102 , $$READING_SYSTEM$$, $$V.4.3.1$$, $$$$);
insert into epubtest."Softwares"("name", "id", "type", "version", "notes") values ($$Readium$$, 103, $$READING_SYSTEM$$, $$2.14.2$$, $$
locale = EN-US$$);
insert into epubtest."Softwares"("name", "id", "type", "version", "notes") values ($$Voice Dream Reader$$, 104, $$READING_SYSTEM$$, $$3.2.0$$, $$$$);
insert into epubtest."Softwares"("name", "id", "type", "version", "notes") values ($$Adobe Digital Editions$$, 105, $$READING_SYSTEM$$, $$4.0.2.103411$$, $$upgraded 12/03/2014$$);
insert into epubtest."Softwares"("name", "id", "type", "version", "notes") values ($$Apple Books$$, 106, $$READING_SYSTEM$$, $$7.4.2$$, $$$$);

-- OS
insert into epubtest."Softwares"("name", "id", "type", "version", "notes") values ($$iOS$$, 201, $$OS$$, $$12$$, $$$$);
insert into epubtest."Softwares"("name", "id", "type", "version", "notes") values ($$iOS$$, 202, $$OS$$, $$10.3.3$$, $$$$);
insert into epubtest."Softwares"("name", "id", "type", "version", "notes") values ($$Android$$, 203, $$OS$$, $$9$$, $$$$);
insert into epubtest."Softwares"("name", "id", "type", "version", "notes") values ($$macOS$$, 204, $$OS$$, $$10.15.2$$, $$$$);
insert into epubtest."Softwares"("name", "id", "type", "version", "notes") values ($$Windows$$, 205, $$OS$$, $$10$$, $$$$);

\echo 'TestingEnvironments';
-- voiceover ios 10.3 gitden
insert into epubtest."TestingEnvironments"("input", "tested_with_braille", "tested_with_screenreader", "is_archived", "assistive_technology_id", "os_id", "reading_system_id", "id") values ($$TOUCH$$, false, true, true, 4, 202, 102, 1);
-- voiceover ios 12 kobo
insert into epubtest."TestingEnvironments"("input", "tested_with_braille", "tested_with_screenreader", "is_archived", "assistive_technology_id", "os_id", "reading_system_id", "id") values ($$TOUCH$$, false, true, true, 4, 201, 101, 2);
-- jaws windows readium
insert into epubtest."TestingEnvironments"("input", "tested_with_braille", "tested_with_screenreader", "is_archived", "assistive_technology_id", "os_id", "reading_system_id", "id") values ($$TOUCH$$, false, true, false, 5, 205, 103, 3);
-- talkback android voicedream
insert into epubtest."TestingEnvironments"("input", "tested_with_braille", "tested_with_screenreader", "is_archived", "assistive_technology_id", "os_id", "reading_system_id", "id") values ($$KEYBOARD$$, false, true, true, 1, 203, 104, 4);
-- nvda windows adobe digital editions
insert into epubtest."TestingEnvironments"("input", "tested_with_braille", "tested_with_screenreader", "is_archived", "assistive_technology_id", "os_id", "reading_system_id", "id") values ($$KEYBOARD$$, false, true, true, 6, 205, 105, 5);
-- voiceover macos apple books
insert into epubtest."TestingEnvironments"("input", "tested_with_braille", "tested_with_screenreader", "is_archived", "assistive_technology_id", "os_id", "reading_system_id", "id") values ($$KEYBOARD$$, false, true, true, 4, 204, 106, 6);
