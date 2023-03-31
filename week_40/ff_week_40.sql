------------------------------------------------------------
-- Frosty Friday Week 40
-- https://frostyfriday.org/2023/03/31/week-40-basic/
------------------------------------------------------------
use role jamielaird;
use database jamielaird;
use schema frosty_friday;

------------------------------------------------------------
-- Solution
------------------------------------------------------------
-- Create function
create or replace function revenue()
returns number(37,4)
memoizable
as $$
select revenue
from (
    select sum((l_extendedprice-l_discount)*l_quantity) as revenue
    from snowflake_sample_data.tpch_sf100.lineitem
        inner join snowflake_sample_data.tpch_sf100.orders on l_orderkey = o_orderkey
        inner join snowflake_sample_data.tpch_sf100.customer on o_custkey = c_custkey
        inner join snowflake_sample_data.tpch_sf100.nation on c_nationkey = n_nationkey
        inner join snowflake_sample_data.tpch_sf100.region on n_regionkey = r_regionkey
    where r_name = 'EUROPE'
)
$$;

-- Run function
select revenue();

------------------------------------------------------------
-- Cleanup
------------------------------------------------------------
drop function if exists revenue();

------------------------------------------------------------
-- References
------------------------------------------------------------
-- https://medium.com/snowflake/faster-snowflake-udfs-and-policies-with-memoizable-b84544c1bf5