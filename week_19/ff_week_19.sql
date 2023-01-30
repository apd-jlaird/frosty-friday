------------------------------------------------------------
-- Frosty Friday Week 19
-- https://frostyfriday.org/2022/10/21/week-19-basic/
------------------------------------------------------------
use role jamielaird;
use database jamielaird;
use schema frosty_friday;

-- Set start and end date variables and calculate rows needed
set start_date = '2000-01-01';
set row_count = (select datediff(days, $start_date, current_date()));

create or replace table ff_week_19 as (
    -- Generate dates between start and end date
    with dates as (
        select
            dateadd(day, seq4(), to_date($start_date)) as date
        from
            table(generator(rowcount => $row_count))
    ),

    -- Generate formatted date versions
    date_formats as (
        select
            date,
            year(date) as year,
            monthname(date) as month_short,
            to_char(date,'MMMM') as month_long,
            day(date) as day_of_month,
            dayofweek(date) as day_of_week,
            weekofyear(date) as week_of_year,
            dayofyear(date) as day_of_year
        from dates
    )

    select * from date_formats
);

-- Check date dimension
select * from ff_week_19;

-- Create business days function


-- Testing
-- ff_week_19_testing


-- Cleanup
unset start_date;
unset row_count;
drop table if exists ff_week_19;
drop table if exists ff_week_19_testing;