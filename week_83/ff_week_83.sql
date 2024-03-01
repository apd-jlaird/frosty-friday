------------------------------------------------------------
-- Frosty Friday Week 83
-- https://frostyfriday.org/blog/2024/03/01/week-83-basic/
------------------------------------------------------------
use role jamielaird;
use database jamielaird;
use schema frosty_friday;

------------------------------------------------------------
-- Startup Code
------------------------------------------------------------
-- Create sales_data table
CREATE TABLE sales_data (
  product_id INT,
  quantity_sold INT,
  price DECIMAL(10,2),
  transaction_date DATE
);

-- Insert sample values
INSERT INTO sales_data (product_id, quantity_sold, price, transaction_date)
VALUES
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
qualify ROW_NUMBER() over (order by REVENUE desc) <= 10);

------------------------------------------------------------
-- Cleanup
------------------------------------------------------------
drop table FROSTY_FRIDAY.SALES_DATA;

------------------------------------------------------------
-- References
------------------------------------------------------------
-- https://docs.snowflake.com/en/sql-reference/constructs/qualify