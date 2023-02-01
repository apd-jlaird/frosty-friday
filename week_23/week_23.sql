------------------------------------------------------------
-- Frosty Friday Week 23
-- https://frostyfriday.org/2022/11/18/week-23-basic/
------------------------------------------------------------

/*

------------------------------------------------------------
-- TERMINAL
------------------------------------------------------------

-- Create data directory and exclude from source control
$ mkdir ~/Code/frosty-friday/week_23/data
$ echo 'week_23/data/' > ~/Code/frosty-friday/.gitignore

-- Download source file to subdirectory
$ curl https://frostyfridaychallenges.s3.eu-west-1.amazonaws.com/challenge_23/splitcsv-c18c2b43-ca57-4e6e-8d95-f2a689335892-results.zip --output ~/Code/frosty-friday/week_23/data/src_file.zip

-- Unzip fle
$ cd ~/Code/frosty-friday/week_23/data
$ unzip ./src_file.zip

-- Cleanup
$ mv ./splitcsv* ./unzipped
$ rm -rf ./__MACOSX

-- Open SnowSQL
$ snowsql

*/

------------------------------------------------------------
-- SNOWSQL
------------------------------------------------------------

-- Set database, warehouse and schema
use database jamielaird;
use warehouse jamielaird;
use schema frosty_friday;

-- Create stage
create stage ff_week_23;

-- Put files ending in 1 to stage
put '~/Code/frosty-friday/week_23/data/unzipped/data_batch_*1.csv' @ff_week_23;

-- List files in stage
list @ff_week_23;

-- Create non-delimited file format
create or replace file format ff_week_23_csv
    type = CSV
    field_delimiter = '|'
    skip_header = 0;

-- Inspect data
select
    $1,
    metadata$filename
from @ff_week_23 (file_format => 'ff_week_23_csv');

-- Change file format to comma separated and skip header row
create or replace file format ff_week_23_csv
    type = CSV
    field_delimiter = ','
    skip_header = 1
    field_optionally_enclosed_by = '"';

-- Create target table
create or replace table ff_week_23 (
    id int,
    first_name varchar,
    last_name varchar,
    email varchar,
    gender varchar,
    ip_address varchar,
    filename varchar,
    file_row_number int,
    loaded_at timestamp_ntz default current_timestamp()
);

-- Copy into table, skipping errors
copy into ff_week_23 (id, first_name, last_name, email, gender, ip_address, filename, file_row_number)
from (
    select
        $1::int as id,
        $2::varchar as first_name,
        $3::varchar as last_name,
        $4::varchar as email,
        $5::varchar as gender,
        $6::varchar as ip_address,
        metadata$filename as filename,
        metadata$file_row_number as file_row_number
    from @ff_week_23 (file_format => 'ff_week_23_csv'))
    on_error = 'skip_file';

-- Check target table
select * from ff_week_23;

-- Cleanup
drop stage if exists ff_week_23;
drop file format if exists ff_week_23_csv;
drop table if exists ff_week_23;

-- Exit SnowSQL
!quit