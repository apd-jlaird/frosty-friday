------------------------------------------------------------
-- Frosty Friday Week 8
-- https://frostyfriday.org/2022/08/05/week-8-basic/
------------------------------------------------------------
use role jamielaird;
use database jamielaird;
use schema frosty_friday;

-- Create external stage
create or replace stage ff_week_8
    url = 's3://frostyfridaychallenges/challenge_8/';

-- Create file format
create or replace file format ff_week_8_csv
    type = csv
    field_delimiter = ','
    skip_header = 1;

select $1 from @ff_week_8/payments.csv (file_format => ff_week_8_csv);

-- Load to table
create or replace table ff_week_8 as (
    select
        $1::number as id,
        $2::varchar as payment_date,
        $3::varchar as card_type,
        $4::number as amount_spent
    from @ff_week_8/payments.csv (file_format => ff_week_8_csv)
);

-- Cleanup
drop stage if exists ff_week_8;
drop file format if exists ff_week_8_csv;
drop table if exists ff_week_8;