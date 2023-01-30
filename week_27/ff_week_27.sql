------------------------------------------------------------
-- Frosty Friday Week 27
-- https://frostyfriday.org/2022/12/16/week-27-beginner/
------------------------------------------------------------
use role jamielaird;
use database jamielaird;
use schema frosty_friday;

-- Select * excluding milktype
select * exclude milktype -- https://docs.snowflake.com/en/sql-reference/sql/select.html#parameters
from ff_week_27;

-- Rename icecreambrandowner to ice_cream_brand_owner
select * rename icecreambrandowner as ice_cream_brand_owner -- https://docs.snowflake.com/en/sql-reference/sql/select.html#parameters
from ff_week_27;

-- Combined query
select *
    exclude milktype
    rename icecreambrandowner as ice_cream_brand_owner
from ff_week_27;

-- Cleanup
drop table if exists ff_week_27;