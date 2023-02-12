------------------------------------------------------------
-- Frosty Friday Week 33
-- https://frostyfriday.org/2023/02/10/week-33-hard/
------------------------------------------------------------
use role jamielaird;
use database jamielaird;
use schema frosty_friday;

------------------------------------------------------------
-- STEP 1: CREATE CLUSTERED TABLES
------------------------------------------------------------
-- Create clustered tables from sample data
create or replace table cluster_sample_1 as (select * from snowflake_sample_data.tpcds_sf10tcl.customer);
alter table cluster_sample_1 cluster by (c_customer_sk);

create or replace table cluster_sample_2 as (select * from snowflake_sample_data.tpcds_sf10tcl.customer_address);
alter table cluster_sample_2 cluster by (ca_address_sk);

-- Check clustering depth
select system$clustering_depth('cluster_sample_1');
select system$clustering_depth('cluster_sample_2');

------------------------------------------------------------
-- STEP 2: IDENTIFY CLUSTERED TABLES
------------------------------------------------------------
-- Create stored procedure to create transient table of clustered tables
create or replace procedure ff_identify_tables()
    returns string null
    language sql
as
$$
begin
  create or replace transient table ff_clustered_tables as (
    select
        table_catalog,
        table_schema,
        table_name,
        current_timestamp() as inserted_at
    from information_schema.tables
    where clustering_key is not null);
end;
$$
;

-- Create task to call stored procedure
create or replace task ff_identify_tables
    warehouse = jamielaird
as
call ff_identify_tables();

-- Test task
execute task ff_identify_tables;
select * from ff_clustered_tables; -- expect table to be returned

------------------------------------------------------------
-- STEP 3: CHECK CLUSTERING DEPTH
------------------------------------------------------------
-- Create monitoring table
create or replace table ff_cluster_depth_monitoring (
    database_name varchar,
    schema_name varchar,
    table_name varchar,
    clustering_depth float,
    inserted_at timestamp,
    inserted_by varchar
);

-- Create Snowpark stored procedure to:
-- (1) read list of tables
-- (2) check cluster depth for each table
-- (3) insert result into monitoring table

create or replace procedure ff_check_tables()
    returns string
    language python
    runtime_version = '3.8'
    packages = ('snowflake-snowpark-python')
    handler = 'main'
as
$$
def main(snowpark_session):

    df_tables = snowpark_session.table("ff_clustered_tables").collect()

    for i in df_tables:
        database_name = i.as_dict()["TABLE_CATALOG"]
        schema_name = i.as_dict()["TABLE_SCHEMA"]
        table_name = i.as_dict()["TABLE_NAME"]

        snowpark_session.sql(f'''

        insert into ff_cluster_depth_monitoring(database_name,schema_name,table_name,clustering_depth,inserted_at,inserted_by)
        select
            '{database_name}' as database_name,
            '{schema_name}' as schema_name,
            '{table_name}' as table_name,
            system$clustering_depth('{database_name}.{schema_name}.{table_name}') as clustering_depth,
            current_timestamp() as inserted_at,
            current_user() as inserted_by

        ''').collect()

$$
;

-- Create task to call stored procedure
create or replace task ff_check_tables
    warehouse = jamielaird
    after ff_identify_tables
as
call ff_check_tables();

-- Test task
execute task ff_check_tables;
select * from ff_cluster_depth_monitoring;

------------------------------------------------------------
-- STEP 4: DROP TRANSIENT TABLE
------------------------------------------------------------
-- Create task to drop transient table
create or replace task ff_drop_transient_table
    warehouse = jamielaird
    after ff_check_tables
as
drop table if exists ff_clustered_tables;

-- Test task
execute task ff_drop_transient_table;
select * from ff_clustered_tables; -- expect error

------------------------------------------------------------
-- STEP 5: TESTING & CLEANUP
------------------------------------------------------------
-- Remove previous results
truncate table ff_cluster_depth_monitoring;

-- Resume non-initial tasks
alter task ff_check_tables resume;
alter task ff_drop_transient_table resume;

-- Execute initial task
execute task ff_identify_tables;

-- Check transient table does not exist
select * from ff_identify_tables; -- expect error

-- Check new values in monitoring table
select * from ff_cluster_depth_monitoring;

-- Cleanup
drop table if exists ff_cluster_depth_monitoring;
drop table if exists cluster_sample_1;
drop table if exists cluster_sample_2;
drop procedure if exists ff_identify_tables();
drop task if exists ff_identify_tables;
drop procedure if exists ff_check_tables();
drop task if exists ff_check_tables();
drop task if exists ff_drop_transient_table;

------------------------------------------------------------
-- RESOURCES
------------------------------------------------------------
-- https://docs.snowflake.com/en/sql-reference/functions/system_clustering_depth.html
-- https://docs.snowflake.com/en/sql-reference/stored-procedures-python.html
-- https://interworks.com/blog/2022/08/16/a-definitive-guide-to-python-stored-procedures-in-the-snowflake-ui/