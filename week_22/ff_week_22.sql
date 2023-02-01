------------------------------------------------------------
-- Frosty Friday Week 22
-- https://frostyfriday.org/2022/11/11/week-22-basic/
------------------------------------------------------------
use role jamielaird;
use database jamielaird;
use schema frosty_friday;

-- File format to read the CSV
create or replace file format ff_week_22_csv
    type = csv
    field_delimiter = ','
    field_optionally_enclosed_by = '"'
    skip_header = 1;

-- Creates stage to read the CSV
create or replace stage ff_week_22
  url = 's3://frostyfridaychallenges/challenge_22/'
  file_format = ff_week_22_csv;

-- Switch role
use role securityadmin;

-- Roles needed for challenge
create role ff_week_21_rep1;
create role ff_week_21_rep2;

-- Grant roles to self for testing
grant role ff_week_21_rep1 to user jamielaird;
grant role ff_week_21_rep2 to user jamielaird;

-- Enable warehouse usage
grant usage on warehouse jamielaird to role ff_week_21_rep1;
grant usage on warehouse jamielaird to role ff_week_21_rep2;

-- Switch role
use role jamielaird;

-- Create the table from the CSV in S3
create or replace table jamielaird.frosty_friday.ff_week_22 as
select t.$1::int id, t.$2::varchar(50) city, t.$3::int district from @ff_week_22 (pattern=>'.*sales_areas.*') t;

-- Code for creating the secure view
create or replace secure view vw_ff_week_22 as (
    select
        uuid_string() as masked_id,
        city,
        district
    from ff_week_22
    where id % 2 = (
        select
            case
                when current_role() = 'FF_WEEK_21_REP1' then 1 -- odd ids
                when current_role() = 'FF_WEEK_21_REP2' then 0 -- even ids
                else null
            end as mod
    )

);

-- Grant database access to roles
grant usage on database jamielaird to role ff_week_21_rep1;
grant usage on database jamielaird to role ff_week_21_rep2;

-- Grant schema access
grant usage on schema jamielaird.frosty_friday to role ff_week_21_rep1;
grant usage on schema jamielaird.frosty_friday to role ff_week_21_rep2;

-- Grant table access
grant select on table ff_week_22 to role ff_week_21_rep1;
grant select on table ff_week_22 to role ff_week_21_rep2;

-- Grant view access
grant select on view jamielaird.frosty_friday.vw_ff_week_22 to role ff_week_21_rep1;
grant select on view jamielaird.frosty_friday.vw_ff_week_22 to role ff_week_21_rep2;

-- Grant warehouse usage
grant usage on warehouse jamielaird to role ff_week_21_rep1;
grant usage on warehouse jamielaird to role ff_week_21_rep2;

-- Get the result of queries
use role ff_week_21_rep1;
select * from jamielaird.frosty_friday.vw_ff_week_22;

use role ff_week_21_rep2;
select * from jamielaird.frosty_friday.vw_ff_week_22;

-- Cleanup
use role jamielaird;
drop file format if exists ff_week_22_csv;
drop stage if exists ff_week_22;
drop table if exists ff_week_22;
drop view if exists vw_ff_week_22;

use role securityadmin;
drop role ff_week_21_rep1;
drop role ff_week_21_rep2;