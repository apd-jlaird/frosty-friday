------------------------------------------------------------
-- Frosty Friday Week 39
-- https://frostyfriday.org/2023/03/24/week-39-basic/
------------------------------------------------------------
use role jamielaird;
use database jamielaird;
use schema frosty_friday;

------------------------------------------------------------
-- Startup Code
------------------------------------------------------------
create or replace table customer_deets (
    id int,
    name string,
    email string
);

insert into customer_deets values
    (1, 'Jeff Jeffy', 'jeff.jeffy121@gmail.com'),
    (2, 'Kyle Knight', 'kyleisdabest@hotmail.com'),
    (3, 'Spring Hall', 'hall.yay@gmail.com'),
    (4, 'Dr Holly Ray', 'drdr@yahoo.com');

------------------------------------------------------------
-- Solution
------------------------------------------------------------
-- Create masking policy
create or replace masking policy email_mask as (val string) returns string ->
    case
        when current_role() = 'JAMIELAIRD' then val
        else regexp_replace(val, '^[^@]+', '*****')
    end;

-- Apply to column
alter table if exists customer_deets modify column email set masking policy email_mask;

-- Test with own role
use role jamielaird;
select * from customer_deets;

-- Test with other role
use role accountadmin;
select * from customer_deets;

------------------------------------------------------------
-- Cleanup
------------------------------------------------------------
drop table if exists customer_deets;
drop masking policy if exists email_mask;

------------------------------------------------------------
-- References
------------------------------------------------------------
-- https://docs.snowflake.com/en/user-guide/security-column-ddm-use