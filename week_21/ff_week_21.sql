------------------------------------------------------------
-- Frosty Friday week_21
------------------------------------------------------------

-- Starting data
create or replace table hero_powers (
hero_name VARCHAR(50),
flight VARCHAR(50),
laser_eyes VARCHAR(50),
invisibility VARCHAR(50),
invincibility VARCHAR(50),
psychic VARCHAR(50),
magic VARCHAR(50),
super_speed VARCHAR(50),
super_strength VARCHAR(50)
);
insert into hero_powers (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('The Impossible Guard', '++', '-', '-', '-', '-', '-', '-', '+');
insert into hero_powers (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('The Clever Daggers', '-', '+', '-', '-', '-', '-', '-', '++');
insert into hero_powers (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('The Quick Jackal', '+', '-', '++', '-', '-', '-', '-', '-');
insert into hero_powers (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('The Steel Spy', '-', '++', '-', '-', '+', '-', '-', '-');
insert into hero_powers (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('Agent Thundering Sage', '++', '+', '-', '-', '-', '-', '-', '-');
insert into hero_powers (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('Mister Unarmed Genius', '-', '-', '-', '-', '-', '-', '-', '-');
insert into hero_powers (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('Doctor Galactic Spectacle', '-', '-', '-', '++', '-', '-', '-', '+');
insert into hero_powers (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('Master Rapid Illusionist', '-', '-', '-', '-', '++', '-', '+', '-');
insert into hero_powers (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('Galactic Gargoyle', '+', '-', '-', '-', '-', '-', '++', '-');
insert into hero_powers (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('Alley Cat', '-', '++', '-', '-', '-', '-', '-', '+');

-- Solution
with main_power as (
    select hero_name, power from hero_powers
        unpivot(value for power in (flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength))
        where value = '++'
    ),
secondary_power as (
    select hero_name, power from hero_powers
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