------------------------------------------------------------
-- Frosty Friday Week 21 - Starter Code
------------------------------------------------------------
use role jamielaird;
use database jamielaird;
use schema frosty_friday;

-- Create table
create or replace table ff_week_21 (
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

-- Insert records
insert into ff_week_21 (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('The Impossible Guard', '++', '-', '-', '-', '-', '-', '-', '+');
insert into ff_week_21 (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('The Clever Daggers', '-', '+', '-', '-', '-', '-', '-', '++');
insert into ff_week_21 (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('The Quick Jackal', '+', '-', '++', '-', '-', '-', '-', '-');
insert into ff_week_21 (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('The Steel Spy', '-', '++', '-', '-', '+', '-', '-', '-');
insert into ff_week_21 (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('Agent Thundering Sage', '++', '+', '-', '-', '-', '-', '-', '-');
insert into ff_week_21 (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('Mister Unarmed Genius', '-', '-', '-', '-', '-', '-', '-', '-');
insert into ff_week_21 (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('Doctor Galactic Spectacle', '-', '-', '-', '++', '-', '-', '-', '+');
insert into ff_week_21 (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('Master Rapid Illusionist', '-', '-', '-', '-', '++', '-', '+', '-');
insert into ff_week_21 (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('Galactic Gargoyle', '+', '-', '-', '-', '-', '-', '++', '-');
insert into ff_week_21 (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('Alley Cat', '-', '++', '-', '-', '-', '-', '-', '+');
