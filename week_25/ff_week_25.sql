------------------------------------------------------------
-- Frosty Friday Week 25
-- https://frostyfriday.org/2022/11/30/week-25-beginner/
------------------------------------------------------------
use role jamielaird;
use database jamielaird;
use schema frosty_friday;

------------------------------------------------------------
-- LANDING ZONE
------------------------------------------------------------
-- Create external stage
create or replace stage ff_week_25
    url = 's3://frostyfridaychallenges/challenge_25/';

-- List stage
list @ff_week_25;

-- Create file format
create or replace file format ff_week_25_json
    type = json
    strip_outer_array = true;

-- Create raw table
create or replace table weather_raw (
    id int identity not null,
    raw_json variant,
    filename varchar not null,
    inserted_at timestamp_ntz default current_timestamp()
);

-- Copy into raw table
copy into weather_raw (raw_json, filename) from (
    select
        $1::variant as raw_json,
        metadata$filename as filename
    from @ff_week_25/ber_7d_oct_clim.json (file_format => ff_week_25_json)
);

-- Check raw table
select * from weather_raw;

------------------------------------------------------------
-- CURATED ZONE
------------------------------------------------------------
create or replace table weather_parsed as (
    select
        l2.value:timestamp::date as date,
        l2.value:icon::text as icon,
        l2.value:temperature::float as temperature,
        l2.value:precipitation::float as precipitation,
        l2.value:wind_speed::float as wind_speed,
        l2.value:relative_humidity::float as relative_humidity
    from weather_raw l1,
    lateral flatten(input => raw_json:weather) l2
);

-- Check parsed table
select * from weather_parsed;

------------------------------------------------------------
-- CONSUMPTION ZONE
------------------------------------------------------------
create or replace view weather_agg as (
    select
        date,
        array_agg(distinct icon) within group (order by icon) as icon_array,
        avg(temperature) as avg_temperature,
        sum(precipitation) as tot_precipitation,
        avg(wind_speed) as avg_wind_speed,
        avg(relative_humidity) as avg_relative_humidity
    from weather_parsed
    group by date
    order by date asc
);

-- Check aggregated view
select * from weather_agg;

------------------------------------------------------------
-- CLEANUP
------------------------------------------------------------
drop stage if exists ff_week_25;
drop file format if exists ff_week_25_json;
drop table if exists weather_raw;
drop table if exists weather_parsed;
drop view if exists weather_agg;