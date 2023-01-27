------------------------------------------------------------
-- Frosty Friday Week 2
------------------------------------------------------------
use role jamielaird;
use database jamielaird;
use schema frosty_friday;

-- Create external stage
create or replace stage ff_week_2
    url = 's3://frostyfridaychallenges/challenge_2/';

-- List files in stage
list @ff_week_2;

-- Create file format
create or replace file format ff_week_2 type = parquet;

-- Check first 3 rows of file in stage to validate schema
select $1::variant from @ff_week_2/employees.parquet (file_format => 'ff_week_2') where metadata$file_row_number <= 3;

-- Create raw data table
create or replace table ff_week_2_raw (
    id int identity(1,1) not null,
    raw variant,
    metadata_filename varchar,
    metadata_file_row_number int,
    loaded_at timestamp_ntz default current_timestamp()
);

-- Copy into raw data table
copy into ff_week_2_raw (raw, metadata_filename, metadata_file_row_number) from (
    select $1::variant, metadata$filename, metadata$file_row_number from @ff_week_2/employees.parquet (file_format => 'ff_week_2')
);

-- Check raw data table
select * from ff_week_2_raw;

-- Create transformed data table
create or replace table ff_week_2 (
    id int identity(1,1) not null,
    raw_id int,
    city varchar,
    country varchar,
    country_code varchar,
    dept varchar,
    education varchar,
    email varchar,
    employee_id int,
    first_name varchar,
    job_title varchar,
    last_name varchar,
    payroll_iban varchar,
    postcode varchar,
    street_name varchar,
    street_num varchar,
    time_zone varchar,
    title varchar,
    loaded_at timestamp_ntz default current_timestamp()
);

-- Insert data from raw table
insert into ff_week_2 (raw_id, city, country, country_code, dept, education, email, employee_id, first_name, job_title, last_name, payroll_iban, postcode, street_name, street_num, time_zone, title)
select
    id as raw_id,
    raw:city,
    raw:country,
    raw:country_code,
    raw:dept,
    raw:education,
    raw:email,
    raw:employee_id,
    raw:first_name,
    raw:job_title,
    raw:last_name,
    raw:payroll_iban,
    raw:postcode,
    raw:street_name,
    raw:street_num,
    raw:time_zone,
    raw:title
from ff_week_2_raw;

-- Check transformed data table
select * from ff_week_2;

-- Create view to track changes to ff_week_2
create or replace view ff_week_2_changes as
    select
        employee_id,
        dept,
        job_title
    from ff_week_2;

-- Check view
select * from ff_week_2_changes;

-- Create stream
create or replace stream ff_week_2_stream on view ff_week_2_changes;

-- Check stream before changes
select * from ff_week_2_stream;

-- Execute changes
UPDATE ff_week_2 SET COUNTRY = 'Japan' WHERE EMPLOYEE_ID = 8;
UPDATE ff_week_2 SET LAST_NAME = 'Forester' WHERE EMPLOYEE_ID = 22;
UPDATE ff_week_2 SET DEPT = 'Marketing' WHERE EMPLOYEE_ID = 25;
UPDATE ff_week_2 SET TITLE = 'Ms' WHERE EMPLOYEE_ID = 32;
UPDATE ff_week_2 SET JOB_TITLE = 'Senior Financial Analyst' WHERE EMPLOYEE_ID = 68;

-- Check stream after changes
select * from ff_week_2_stream;

-- Cleanup
drop stage ff_week_2;
drop file format ff_week_2;
drop table ff_week_2_raw;
drop table ff_week_2;
drop view ff_week_2_changes;
drop stream ff_week_2_stream;