------------------------------------------------------------
-- Frosty Friday Week 35
-- https://frostyfriday.org/2023/02/24/week-35-intermediate/
------------------------------------------------------------
use role jamielaird;
use database jamielaird;
use schema frosty_friday;

------------------------------------------------------------
-- Startup Code
------------------------------------------------------------
create stage w35_external_stage
	url = 's3://frostyfridaychallenges/challenge_35/';

------------------------------------------------------------
-- Solution
------------------------------------------------------------
-- List stage
list @w35_external_stage;

-- Create file format for inspecting files
create or replace file format w35_csv
    type = csv
    field_delimiter = '|'
    skip_header = 0
    field_optionally_enclosed_by = '"';

-- Inspect file
select $1 from @w35_external_stage/2022/01/salesdata_71983.csv (file_format => w35_csv);

-- Create external table
create or replace external table w35_external_table (
    sale_month date as (to_date(regexp_substr(metadata$filename, '\\d{4}\/\\d{2}')||'/01', 'YYYY/MM/DD')),
    id int as (value:c1::int),
    drug_name string as (value:c2::string),
    amount_sold number as (value:c3::number)
)
location = @w35_external_stage/
pattern = '.*[.]csv'
file_format = (type = csv skip_header = 1 field_optionally_enclosed_by = '"');

-- Check external table
select sale_month, id, drug_name, amount_sold from w35_external_table;

------------------------------------------------------------
-- Testing
------------------------------------------------------------
select
    sale_month,
    id,
    drug_name,
    amount_sold
from w35_external_table
order by amount_sold;

------------------------------------------------------------
-- Cleanup
------------------------------------------------------------
drop stage if exists w35_external_stage;
drop file format if exists w35_csv;
drop table if exists w35_external_table;