------------------------------------------------------------
-- Frosty Friday Week 41
-- https://frostyfriday.org/2023/04/14/week-41-basic
------------------------------------------------------------
use role jamielaird;
use database jamielaird;
use schema frosty_friday;

------------------------------------------------------------
-- Solution
------------------------------------------------------------
call statement_creator();

------------------------------------------------------------
-- Cleanup
------------------------------------------------------------
drop procedure if exists statement_creator();