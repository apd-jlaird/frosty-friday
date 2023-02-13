------------------------------------------------------------
-- Frosty Friday Week 9 - Starter Code
------------------------------------------------------------
use role jamielaird;
use database jamielaird;
use schema frosty_friday;

-- Create target table
create or replace table data_to_be_masked (
    first_name varchar,
    last_name varchar,
    hero_name varchar
);

-- Add data
insert into data_to_be_masked (first_name, last_name, hero_name) values ('Eveleen', 'Danzelman','The Quiet Antman');
insert into data_to_be_masked (first_name, last_name, hero_name) values ('Harlie', 'Filipowicz','The Yellow Vulture');
insert into data_to_be_masked (first_name, last_name, hero_name) values ('Mozes', 'McWhin','The Broken Shaman');
insert into data_to_be_masked (first_name, last_name, hero_name) values ('Horatio', 'Hamshere','The Quiet Charmer');
insert into data_to_be_masked (first_name, last_name, hero_name) values ('Julianna', 'Pellington','Professor Ancient Spectacle');
insert into data_to_be_masked (first_name, last_name, hero_name) values ('Grenville', 'Southouse','Fire Wonder');
insert into data_to_be_masked (first_name, last_name, hero_name) values ('Analise', 'Beards','Purple Fighter');
insert into data_to_be_masked (first_name, last_name, hero_name) values ('Darnell', 'Bims','Mister Majestic Mothman');
insert into data_to_be_masked (first_name, last_name, hero_name) values ('Micky', 'Shillan','Switcher');
insert into data_to_be_masked (first_name, last_name, hero_name) values ('Ware', 'Ledstone','Optimo');

-- Switch role
use role securityadmin;

-- Create role
create or replace role ff_foo1;
create or replace role ff_foo2;
grant role ff_foo1 to user jamielaird;
grant role ff_foo2 to user jamielaird;