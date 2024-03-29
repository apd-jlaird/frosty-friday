------------------------------------------------------------
-- Frosty Friday Week 87
-- https://frostyfriday.org/blog/2024/03/29/week-87-basic/
------------------------------------------------------------
use role JAMIELAIRD;
use database JAMIELAIRD;
use schema FROSTY_FRIDAY;

------------------------------------------------------------
-- Startup Code
------------------------------------------------------------
create or replace table WEEK_87 as
select 
  'Happy Easter' as GREETING,
  array_construct('DE', 'FR', 'IT', 'ES', 'PL', 'RO', 'JA', 'KO', 'PT') as LANGUAGE_CODES
;

------------------------------------------------------------
-- Solution
------------------------------------------------------------
select
    GREETING,
    VALUE as LANGUAGE_CODE,
    SNOWFLAKE.CORTEX.TRANSLATE(GREETING, 'EN', LANGUAGE_CODE) as TRANSLATED_GREETING
from WEEK_87,
    lateral flatten(input => LANGUAGE_CODES);

------------------------------------------------------------
-- Cleanup
------------------------------------------------------------
drop table if exists WEEK_87;

------------------------------------------------------------
-- References
------------------------------------------------------------
-- https://docs.snowflake.com/en/sql-reference/functions/translate-snowflake-cortex