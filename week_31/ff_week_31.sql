------------------------------------------------------------
-- Frosty Friday Week 31
-- https://frostyfriday.org/2023/01/27/week-31-basic/
------------------------------------------------------------
use role jamielaird;
use database jamielaird;
use schema frosty_friday;

-- Starting data
create or replace table ff_week_31 (
    id int,
    hero_name varchar,
    villains_defeated int
);

insert into ff_week_31 values
  (1, 'Pigman', 5),
  (2, 'The OX', 10),
  (3, 'Zaranine', 4),
  (4, 'Frostus', 8),
  (5, 'Fridayus', 1),
  (6, 'SheFrost', 13),
  (7, 'Dezzin', 2.3),
  (8, 'Orn', 7),
  (9, 'Killder', 6),
  (10, 'PolarBeast', 11);

-- Solution
select
    max_by(hero_name, villains_defeated) as best_hero,
    min_by(hero_name, villains_defeated) as worst_hero
from ff_week_31;

-- Cleanup
drop table ff_week_31;