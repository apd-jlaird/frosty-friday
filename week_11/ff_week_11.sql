------------------------------------------------------------
-- Frosty Friday Week 11
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
--select $1 from @ff_week_11/milk_data.csv (file_format => ff_week_11_csv);

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

-- TASK 1: Remove all the centrifuge dates and centrifuge kwph and replace them with NULLs WHERE fat = 3.
-- Add note to task_used.
create or replace task whole_milk_updates
    warehouse = jamielaird
    --schedule = '1400 minutes' -- removed to test
    as
    update ff_week_11
    set
        centrifuge_start_time = null,
        centrifuge_end_time = null,
        centrifuge_processing_time = null,
        centrifuge_kwph = null,
        task_used = system$current_user_task_name() || ' at ' || current_timestamp()
    where fat_percentage = 3;

-- TASK 2: Calculate centrifuge processing time (difference between start and end time) WHERE fat != 3.
-- Add note to task_used.
create or replace task skim_milk_updates
    warehouse = jamielaird
    after whole_milk_updates
    as
    update ff_week_11
    set
        centrifuge_processing_time = datediff(mi, centrifuge_start_time, centrifuge_end_time    ),
        task_used = system$current_user_task_name() || ' at ' || current_timestamp()
    where fat_percentage != 3;

-- Manually execute the task.
execute task whole_milk_updates;

-- Check that the data looks as it should.
select * from ff_week_11;

-- Check that the numbers are correct.
select task_used, count(*) as row_count from ff_week_11 group by task_used;

-- Check task history
select *
from table(information_schema.task_history())
order by scheduled_time desc;

-- Cleanup
drop stage if exists ff_week_11;
drop file format if exists ff_week_11_csv;
drop table if exists ff_week_11;
drop task if exists whole_milk_updates;
drop task if exists skim_milk_updates;