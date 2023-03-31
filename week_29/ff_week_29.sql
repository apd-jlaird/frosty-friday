------------------------------------------------------------
-- Frosty Friday Week 29
-- https://frostyfriday.org/2023/01/13/week-29-intermediate/
------------------------------------------------------------
use role jamielaird;
use database jamielaird;
use schema frosty_friday;

------------------------------------------------------------
-- Startup Code
------------------------------------------------------------
create or replace file format frosty_csv
    type = csv
    skip_header = 1
    field_optionally_enclosed_by = '"';

create stage w29_stage
    url = 's3://frostyfridaychallenges/challenge_29/'
    file_format = frosty_csv;

list @w29_stage;

create table week29 as
select t.$1::int as id,
        t.$2::varchar(100) as first_name,
        t.$3::varchar(100) as surname,
        t.$4::varchar(250) as email,
        t.$5::datetime as start_date
from @w29_stage (pattern=>'.*start_dates.*') t;

------------------------------------------------------------
-- Solution
------------------------------------------------------------

--concat('FY',right(to_char(year(start_date)+1),2))

select
    start_date,
    case
        when month(start_date) >= 5 then concat('FY',right(year(start_date)+1,2))
        else concat('FY',right(year(start_date),2))
    end as adj
from week29;

select 3 >= 5 as test;

------------------------------------------------------------
-- Test
------------------------------------------------------------
data = session.table("week29").select(
    col("id"),
    col("first_name"),
    col("surname"),
    col("email"),
    col("start_date"),
    fiscal_year("start_date").alias("fiscal_year")
)

data.show()

data.group_by("fiscal_year").agg(col("*"), "count").show()

------------------------------------------------------------
-- Cleanup
------------------------------------------------------------
drop file format if exists frosty_csv;
drop stage if exists w29_stage;
drop table if exists week29;

------------------------------------------------------------
-- References
------------------------------------------------------------
-- https://interworks.com/blog/2022/09/06/a-definitive-guide-to-creating-python-udfs-in-snowflake-using-snowpark/