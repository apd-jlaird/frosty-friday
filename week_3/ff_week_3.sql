------------------------------------------------------------
-- Frosty Friday Week 3
-- https://frostyfriday.org/2022/07/15/week-3-basic/
------------------------------------------------------------
use role jamielaird;
use database jamielaird;
use schema frosty_friday;

-- Create external stage
create or replace stage ff_week_3
    url = 's3://frostyfridaychallenges/challenge_3/';

-- Create temporary table for keywords
create or replace temporary table ff_week_3_keywords (
    keyword varchar
);

-- Add keywords to temporary table
copy into ff_week_3_keywords (keyword) from (
    select $1 from @ff_week_3/keywords.csv)
    file_format = (type = csv, skip_header = 1);

-- Create temporary table listing filenames and row counts
create or replace temporary table ff_week_3_filenames (
    filename varchar,
    number_of_rows int
);

-- Query filenames and row counts from stage, skipping keyword file
select
    metadata$filename as filename,
    count(*)-1 as number_of_rows -- skip header row from count
from @ff_week_3
where filename not like '%keywords.csv'
group by 1;

-- Insert into temporary filename table using last query
-- Using -5 for compatibility with DataGrip
-- https://community.snowflake.com/s/question/0D50Z00009C5eieSAB/is-there-a-way-to-select-from-the-list-stage-output-as-a-table)
insert into ff_week_3_filenames (filename, number_of_rows)
    select *
    from table(result_scan(last_query_id(-5)));

-- Create final table
create or replace table ff_week_3 (
    filename varchar,
    number_of_rows int
);

-- Insert into final table, joining the two temporary tables to include only the relevant files
insert into ff_week_3 (filename, number_of_rows)
    select
        f.*
    from ff_week_3_filenames f
    inner join ff_week_3_keywords k
    where contains(f.filename, k.keyword)
    order by number_of_rows;

-- Query final table
select * from ff_week_3;

-- Cleanup
drop stage ff_week_3;
drop table ff_week_3;