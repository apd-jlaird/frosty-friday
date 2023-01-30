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
            dayofweekiso(date) as day_of_week,
            weekofyear(date) as week_of_year,
            dayofyear(date) as day_of_year
        from dates
    )

    select * from date_formats
);

-- Check date dimension
select * from ff_week_19;

/*
Create a function to calculate the number of business days between 2 dates that can easily switch between including
or excluding the 2nd date in the calculation (so From and including Monday, 2 November 2020 to, but not including
Friday, 6 November 2020 is 4 days but From and including Monday, 2 November 2020
to and including Friday, 6 November 2020 is 5 days)
 */

-- Create business days function
create or replace function ff_week_19 (start_date date, end_date date, include_last_day boolean)
returns number as
    $$
    select count(*)
    from ff_week_19
    where day_of_week not in (6,7)
        and date >= start_date
        and date < (end_date + include_last_day::number)
    $$;

-- Test 1
select
    ff_week_19('2020-11-2','2020-11-6',true) as including,
    ff_week_19('2020-11-2','2020-11-6',false) as excluding;

-- Test 2
select
    start_date,
    end_date,
    ff_week_19(start_date, end_date, true) as including,
    ff_week_19(start_date, end_date, false) as excluding
from ff_week_19_testing;

-- Cleanup
unset start_date;
unset row_count;
drop table if exists ff_week_19;
drop table if exists ff_week_19_testing;
drop function if exists ff_week_19(date, date, boolean);