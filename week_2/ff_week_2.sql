------------------------------------------------------------
-- Frosty Friday Week 2
------------------------------------------------------------
use role jamielaird;
use database jamielaird;
use schema frosty_friday;

-- Create external stage
create or replace stage ff_week_2
    url = 's3://frostyfridaychallenges/challenge_2/';

-- List files in stage
list @ff_week_2;

-- Create file format
create or replace file format ff_week_2 type = parquet;

-- Check first 5 rows x 5 columns of each file in stage to validate schema
select $1::variant from @ff_week_2/employees.parquet (file_format => 'ff_week_2');

-- Create raw data table
create or replace table ff_week_2 (
    raw variant,
    metadata_filename text,
    metadata_file_row_number int,
    loaded_at timestamp_ntz default current_timestamp()
);


select $1 from @ff_week_2/employees.parquet;

https://frostyfridaychallenges.s3.eu-west-1.amazonaws.com/challenge_2/employees.parquet


-- Cleaup
drop stage ff_week_2;