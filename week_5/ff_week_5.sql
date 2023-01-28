------------------------------------------------------------
-- Frosty Friday Week 5
-- https://frostyfriday.org/2022/07/15/week-5-basic/
------------------------------------------------------------
use role jamielaird;
use database jamielaird;
use schema frosty_friday;

-- Create starting table
create or replace table ff_week_5 as (
    select 3 as start_int
);

-- Create function
-- https://docs.snowflake.com/en/developer-guide/udf/python/udf-python-creating.html#creating-an-in-line-python-udf
create or replace function timesthree(i int)
returns int
language python
runtime_version = '3.8'
handler = 'timesthree_py'
as
$$
def timesthree_py(i):
  return i*3
$$;

-- Test function
select timesthree(start_int) from ff_week_5;