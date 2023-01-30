------------------------------------------------------------
-- Frosty Friday Week 27 - Starter Code
------------------------------------------------------------
use role jamielaird;
use warehouse jamielaird;
use database jamielaird;
use schema frosty_friday;

create or replace table ff_week_27
(
    icecream_id int,
    icecream_flavour varchar(15),
    icecream_manufacturer varchar(50),
    icecream_brand varchar(50),
    icecreambrandowner varchar(50),
    milktype varchar(15),
    region_of_origin varchar(50),
    recomendad_price number,
    wholesale_price number
);

insert into ff_week_27 values
    (1, 'strawberry', 'Jimmy Ice', 'Ice Co.', 'Food Brand Inc.', 'normal', 'Midwest', 7.99, 5),
    (2, 'vanilla', 'Kelly Cream Company', 'Ice Co.', 'Food Brand Inc.', 'dna-modified', 'Northeast', 3.99, 2.5),
    (3, 'chocolate', 'ChoccyCream', 'Ice Co.', 'Food Brand Inc.', 'normal', 'Midwest', 8.99, 5.5);