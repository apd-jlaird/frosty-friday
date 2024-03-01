------------------------------------------------------------
-- Frosty Friday Week 83
-- https://frostyfriday.org/blog/2024/03/01/week-83-basic/
------------------------------------------------------------
use role JAMIELAIRD;
use warehouse JAMIELAIRD;
use database JAMIELAIRD;
use schema FROSTY_FRIDAY;

------------------------------------------------------------
-- Startup Code
------------------------------------------------------------
-- Create sales_data table
create or replace table SALES_DATA (
  PRODUCT_ID int,
  QUANTITY_SOLD int,
  PRICE decimal(10,2),
  TRANSACTION_DATE DATE
);

-- Insert sample values
insert into SALES_DATA (PRODUCT_ID, QUANTITY_SOLD, PRICE, TRANSACTION_DATE) values
  (1, 10, 15.99, '2024-02-01'),
  (1, 8, 15.99, '2024-02-05'),
  (2, 15, 22.50, '2024-02-02'),
  (2, 20, 22.50, '2024-02-07'),
  (3, 12, 10.75, '2024-02-03'),
  (3, 18, 10.75, '2024-02-08'),
  (4, 5, 30.25, '2024-02-04'),
  (4, 10, 30.25, '2024-02-09'),
  (5, 25, 18.50, '2024-02-06'),
  (5, 30, 18.50, '2024-02-10');

------------------------------------------------------------
-- Solution
------------------------------------------------------------
select
  PRODUCT_ID,
  SUM(QUANTITY_SOLD * PRICE) as REVENUE
from
  SALES_DATA
group by
  PRODUCT_ID
qualify ROW_NUMBER() over (order by REVENUE desc) <= 10;

------------------------------------------------------------
-- Cleanup
------------------------------------------------------------
drop table FROSTY_FRIDAY.SALES_DATA;

------------------------------------------------------------
-- References
------------------------------------------------------------
-- https://docs.snowflake.com/en/sql-reference/constructs/qualify