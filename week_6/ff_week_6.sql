------------------------------------------------------------
-- Frosty Friday Week 6
-- https://frostyfriday.org/2022/07/22/week-6-hard/
------------------------------------------------------------
use role jamielaird;
use database jamielaird;
use schema frosty_friday;

-- Create external stage
create or replace stage ff_week_6
    url = 's3://frostyfridaychallenges/challenge_6/';

-- Create single column csv file format
create or replace file format ff_week_6_csv_temp
    type = csv
    field_delimiter = '|'
    skip_header = 0;

-- Create delimited csv file format
create or replace file format ff_week_6_csv
    type = csv
    field_delimiter = ','
    skip_header = 1
    field_optionally_enclosed_by = '"';

-- Inspect nations and regions csv
select $1 from @ff_week_6/nations_and_regions.csv (file_format => ff_week_6_csv_temp);

-- Create nations and regions raw data table
create or replace temporary table ff_week_6_nr_raw as (
    select
        $1::varchar as nation_or_region_name,
        $2::varchar as type,
        $3::int as sequence_num,
        $4::real as longitude,
        $5::real as latitude,
        $6::int as part,
        metadata$filename as filename,
        current_timestamp() as loaded_at
    from @ff_week_6/nations_and_regions.csv (file_format => ff_week_6_csv)
);

-- Inspect constituency points csv
select $1 from @ff_week_6/westminster_constituency_points.csv (file_format => ff_week_6_csv_temp);

-- Create constituency points raw data table
create or replace temporary table ff_week_6_cp_raw as (
    select
        $1::varchar as constituency,
        $2::int as sequence_num,
        $3::real as longitude,
        $4::real as latitude,
        $5::int as part,
        metadata$filename as filename,
        current_timestamp() as loaded_at
    from @ff_week_6/westminster_constituency_points.csv (file_format => ff_week_6_csv)
);

 /*
 The steps below are adapted from the following tutorial - all credit to Atzmon Ben Binyamin 🙌
 https://theinformationlab.nl/2022/10/03/geo-spatial-objects-in-snowflake/
 */

-- Creating regional polygons
-- Set geography output format to WKT
alter session set geography_output_format = 'WKT';

create or replace temporary table ff_week_6_nr_polygons as (

-- create a geography object containing each point
with points as (
    select
        nation_or_region_name,
        type,
        sequence_num,
        longitude,
        latitude,
        part,
        st_makepoint(longitude, latitude) as geo_points
    from ff_week_6_nr_raw
),

-- get the first point for nation or region
points_0 as (
    select
        nation_or_region_name,
        type,
        sequence_num,
        longitude,
        latitude,
        part,
        st_makepoint(longitude, latitude) as geo_points_0
    from ff_week_6_nr_raw
    where sequence_num = 0
),

-- collect everything together
collect_points as (
    select
        nation_or_region_name,
        type,
        part,
        array_agg(sequence_num) as seq,
        st_collect(geo_points) as collection_points
    from points
    where sequence_num > 0
    group by 1,2,3
),

-- join start and end points with other points
lines as (
    select
        cp.nation_or_region_name,
        cp.type,
        cp.part,
        cp.seq,
        cp.collection_points,
        pz.geo_points_0
    from collect_points cp
    left join points_0 pz
        on cp.nation_or_region_name = pz.nation_or_region_name
        and cp.type = pz.type
        and cp.part = pz.part
),



)





-- Cleanup
drop stage ff_week_6;
drop file format ff_week_6_csv_temp,
drop file format ff_week_6_csv;