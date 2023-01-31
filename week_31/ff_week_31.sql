------------------------------------------------------------
-- Frosty Friday Week 31
-- https://frostyfriday.org/2023/01/27/week-31-basic/
------------------------------------------------------------
use role jamielaird;
use database jamielaird;
use schema frosty_friday;

-- Solution
select
    max_by(hero_name, villains_defeated) as best_hero,
    min_by(hero_name, villains_defeated) as worst_hero
from ff_week_31;

-- Cleanup
drop table ff_week_31;