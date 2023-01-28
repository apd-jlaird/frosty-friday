------------------------------------------------------------
-- Frosty Friday Week 4
-- https://frostyfriday.org/2022/07/15/week-4-hard/
------------------------------------------------------------
use role jamielaird;
use database jamielaird;
use schema frosty_friday;

-- Create external stage
create or replace stage ff_week_4
    url = 's3://frostyfridaychallenges/challenge_4/';

-- Create file format
create or replace file format ff_week_4
type = json
strip_outer_array = true;

-- Create temporary landing table for raw json
create or replace temporary table ff_week_4_raw (
    raw_json variant,
    filename varchar,
    row_number int,
    loaded_at timestamp_ntz default current_timestamp()
);

-- Copy raw data into landing table
copy into ff_week_4_raw (raw_json, filename, row_number) from (
    select
        $1::variant as raw_json,
        metadata$filename as filename,
        metadata$file_row_number as row_number
    from @ff_week_4/Spanish_Monarchs.json
)
file_format = ff_week_4;

-- Create intermediate temporary table of unordered parsed data
create or replace temporary table ff_week_4_parsed as (
    select
        m.index + 1 as inter_house_id,
        --era
        raw_json:"Era"::varchar as era,
        --house
        h.value:"House"::varchar as house,
        --name
        m.value:"Name"::varchar as name,
        --nickname_1
        m.value:"Nickname"[0]::varchar as nickname_1,
        --nickname_2
        m.value:"Nickname"[1]::varchar as nickname_2,
        --nickname_3
         m.value:"Nickname"[1]::varchar as nickname_3,
        --birth
        m.value:"Birth"::date as birth,
        --place_of_birth
        m.value:"Place of Birth"::varchar as place_of_birth,
        --start_of_reign
        m.value:"Start of Reign"::date as start_of_reign,
        --queen_or_queen_consort_1
        m.value:"Consort\/Queen Consort"::variant[0] as queen_or_queen_consort_1,
        --queen_or_queen_consort_2
        m.value:"Consort\/Queen Consort"::variant[1] as queen_or_queen_consort_2,
        --queen_or_queen_consort_3
        m.value:"Consort\/Queen Consort"::variant[2] as queen_or_queen_consort_3,
        --end_of_reign
        m.value:"End of Reign"::date as end_of_reign,
        --duration
        m.value:"Duration"::varchar as duration,
        --death
        m.value:"Death"::date as death,
        --age_at_time_of_death_years
        m.value:"Age at Time of Death"::varchar as age_at_time_of_death,
        --place_of_death
        m.value:"Place of Death"::varchar as place_of_death,
        --burial_place
        m.value:"Burial Place"::varchar as burial_place
    from ff_week_4_raw,
        lateral flatten(raw_json:"Houses") as h,
        lateral flatten(h.value:"Monarchs") as m
);

-- Create final table with ordering
create or replace table ff_week_4 as (
    select
        row_number() over (order by birth) as id,
        *
    from ff_week_4_parsed
    order by id
);

-- View final table
select * from ff_week_4;

-- Cleanup
drop stage ff_week_4;
drop file format ff_week_4;
drop table ff_week_4;