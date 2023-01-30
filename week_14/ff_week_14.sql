------------------------------------------------------------
-- Frosty Friday Week 14
-- https://frostyfriday.org/2022/09/16/week-14-basic/
------------------------------------------------------------
use role jamielaird;
use database jamielaird;
use schema frosty_friday;

-- Collate superpowers into an array
with array_construct as (
    select
        country_of_residence,
        superhero_name,
        array_construct_compact(superpower,second_superpower,third_superpower) as superpowers
    from ff_week_14
),
-- Create json object from all fields
object_construct as (
    select
        object_construct(*) as superhero_json
    from array_construct
)
select * from object_construct;

-- Cleanup
drop table if exists ff_week_14;