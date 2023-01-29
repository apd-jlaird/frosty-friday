------------------------------------------------------------
-- Frosty Friday Week 7
-- https://frostyfriday.org/2022/07/29/week-7-intermediate/
------------------------------------------------------------
use role securityadmin;
use database jamielaird;
use schema frosty_friday;

-- Create view
create view ff_week_7 as (

    -- Get tag details from tag_references
    with tag_references as (
        select
            object_id,
            object_name as tag_name,
            tag_value
        from snowflake.account_usage.tag_references
        where tag_value = 'Level Super Secret A+++++++'
    ),

    -- Get access history from access_history and parse object attributes
    access_history as (
        select
            ah.query_id,
            ah_bo.value:"objectId"::int as object_id,
            ah_bo.value:"objectName"::varchar as table_name
        from snowflake.account_usage.access_history ah
            ,lateral flatten(ah.BASE_OBJECTS_ACCESSED) ah_bo
    ),

    -- Join tag details with access history
    tag_access as (
        select
            tr.tag_name,
            tr.tag_value,
            ah.query_id,
            ah.table_name
        from tag_references tr
        left join access_history ah
            on tr.object_id = ah.object_id
    ),

    -- Join to query_history to get role name
    query_history as (
        select
            ta.tag_name,
            ta.tag_value,
            ta.query_id,
            ta.table_name,
            qh.role_name
        from snowflake.account_usage.query_history qh
        inner join tag_access ta
            on ta.query_id = qh.query_id
    )

    select * from query_history
);

-- Check view
select * from ff_week_7;

-- Cleanup
use role jamielaird;
drop view if exists ff_week_7;
drop table if exists week7_villain_information;
drop table if exists week7_monster_information;
drop table if exists week7_weapon_storage_location;
drop tag if exists security_class;

use role securityadmin;
drop role if exists ff_user1;
drop role if exists ff_user2;
drop role if exists ff_user3