------------------------------------------------------------
-- FROSTY FRIDAY - WEEK 1
------------------------------------------------------------
-- set context
use role sandbox_dba;
use warehouse dev_wh;
use database sandbox;

-- create schema
create schema ff_week_1;

-- create stage and list files
create stage ff_week_1_stage url='s3://frostyfridaychallenges/challenge_1/';

-- list files in stage
list  @ff_week_1_stage;

-- create file format
create or replace file format ff_week_1_csv
    type = 'csv';

-- preview 10 columns of each file
select $1,$2,$3,$4,$5,$6,$7,$8,$9,$10 from @ff_week_1_csv_stage (file_format => 'ff_week_1_csv_file_format', pattern=>'challenge_1/1.csv');
select $1,$2,$3,$4,$5,$6,$7,$8,$9,$10 from @ff_week_1_csv_stage (file_format => 'ff_week_1_csv_file_format', pattern=>'challenge_1/2.csv');
select $1,$2,$3,$4,$5,$6,$7,$8,$9,$10 from @ff_week_1_csv_stage (file_format => 'ff_week_1_csv_file_format', pattern=>'challenge_1/3.csv');

-- create table


-- copy into

-- cross-check row count between stage and table