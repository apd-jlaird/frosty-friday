------------------------------------------------------------
-- Frosty Friday Week 38
-- https://frostyfriday.org/2023/03/17/week-38-basic/
------------------------------------------------------------
use role jamielaird;
use database jamielaird;
use schema frosty_friday;

------------------------------------------------------------
-- Startup Code
------------------------------------------------------------
-- Create first table
create or replace table employees (
    id int,
    name varchar(50),
    department varchar(50)
);

-- Insert example data into first table
insert into employees (id, name, department)
values
    (1, 'Alice', 'Sales'),
    (2, 'Bob', 'Marketing');

-- Create second table
create or replace table sales (
    id int,
    employee_id int,
    sale_amount decimal(10, 2)
);

-- Insert example data into second table
insert into sales (id, employee_id, sale_amount)
values
    (1, 1, 100.00),
    (2, 1, 200.00),
    (3, 2, 150.00);

-- Create view that combines both tables
create or replace view employee_sales as
    select
        e.id,
        e.name,
        e.department,
        s.sale_amount
    from employees e
    join sales s
        on e.id = s.employee_id;

-- Query the view to verify the data
select * from employee_sales;

------------------------------------------------------------
-- Solution
------------------------------------------------------------
-- Create stream on employee_sales view
create or replace stream employee_sales_stream on view employee_sales;

-- Delete sales 1 and 3 from sales table
delete from sales where id = 1;
delete from sales where id = 3;

-- Create deleted_sales table
create or replace table deleted_sales (
    id int,
    name varchar(50),
    department varchar(50),
    sale_amount decimal(10, 2)
);

-- Insert records from stream to deleted_sales table ** NB this removes the items from the stream **
insert into deleted_sales (id, name, department, sale_amount)  (
    select
        id,
        name,
        department,
        sale_amount
    from employee_sales_stream
    where metadata$action = 'DELETE'
);

-- Check stream
select * from employee_sales_stream; -- expect empty

-- Check deleted_sales table
select * from deleted_sales; -- expect 2 records

------------------------------------------------------------
-- Cleanup
------------------------------------------------------------
drop table if exists employees;
drop table if exists sales;
drop view if exists employee_sales;
drop stream if exists employee_sales_stream;
drop table if exists deleted_sales;

------------------------------------------------------------
-- References
------------------------------------------------------------
-- https://docs.snowflake.com/en/sql-reference/sql/create-stream