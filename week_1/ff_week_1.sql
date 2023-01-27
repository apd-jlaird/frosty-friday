------------------------------------------------------------
-- Frosty Friday Week 1
------------------------------------------------------------
use role jamielaird;
use database jamielaird;
use schema frosty_friday;

-- Create external stage
create or replace stage ff_week_1
    url = 's3://frostyfridaychallenges/challenge_1/';

-- List files in stage
list @ff_week_1;

-- Check first 5 rows x 5 columns of each file in stage to validate schema
select metadata$filename, $1, $2, $3, $4, $5 from @ff_week_1/1.csv
union all
select metadata$filename, $1, $2, $3, $4, $5 from @ff_week_1/2.csv
union all
select metadata$filename, $1, $2, $3, $4, $5 from @ff_week_1/3.csv;

-- Create table (including metadata and loaded at columns)
create or replace table ff_week_1 (
    content text,
    metadata_filename text,
    metadata_file_row_number int,
    loaded_at timestamp_ntz default current_timestamp()
);

-- Copy into table
copy into ff_week_1 (content, metadata_filename, metadata_file_row_number) from (
    select $1, metadata$filename, metadata$file_row_number from @ff_week_1)
    file_format = (type = csv skip_header = 1, null_if = ('NULL', 'totally_empty'), skip_blank_lines = true); -- Skip headers and replace unnecessary rows with NULLS

-- Handle null rows
delete from ff_week_1 where content is null; -- Cannot find a way to do this within the copy statement

-- Query table preserving original row order
select * from ff_week_1 order by 2,3;

-- Cleanup
drop stage ff_week_1;
drop table ff_week_1;