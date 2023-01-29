------------------------------------------------------------
-- Frosty Friday Week 8
-- https://frostyfriday.org/2022/08/26/week-11-basic/
------------------------------------------------------------
use role jamielaird;
use database jamielaird;
use schema frosty_friday;

-- Create external stage
create or replace stage ff_week_11
    url = 's3://frostyfridaychallenges/challenge_11/';

-- Create file format
create or replace file format ff_week_11_csv
    type = csv
    field_delimiter = ','
    skip_header = 1;

-- Explore file
select $1 from @ff_week_11/milk_data.csv (file_format => ff_week_11_csv);

-- Load milk data to table
create or replace table ff_week_11 as (
    select
        $1 as milking_datetime,
        $2 as cow_number,
        $3 as fat_percentage,
        $4 as farm_code,
        $5 as centrifuge_start_time,
        $6 as centrifuge_end_time,
        $7 as centrifuge_kwph,
        $8 as centrifuge_electricity_used,
        $9 as centrifuge_processing_time,
        $10 as task_used,
        metadata$filename as filename,
        current_timestamp() as loaded_at
    from @ff_week_11/milk_data.csv (file_format => ff_week_11_csv)
);

select * from ff_week_11;

-- Cleanup
drop stage if exists ff_week_11;
drop file format if exists ff_week_11_csv;
drop table if exists ff_week_11;