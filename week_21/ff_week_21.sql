------------------------------------------------------------
-- Frosty Friday Week 21
-- https://frostyfriday.org/2022/11/04/week-21-basic/
------------------------------------------------------------
use role jamielaird;
use database jamielaird;
use schema frosty_friday;

with main_power as (
    select hero_name, power from ff_week_21
        unpivot(value for power in (flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength))
        where value = '++'
    ),
secondary_power as (
    select hero_name, power from ff_week_21
        unpivot(value for power in (flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength))
        where value = '+'
    )
select
    main_power.hero_name,
    main_power.power as main_power,
    secondary_power.power as secondary_power
from main_power
left join secondary_power
    on main_power.hero_name = secondary_power.hero_name;

-- Cleanup
drop table ff_week_21;