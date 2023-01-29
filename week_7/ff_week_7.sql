------------------------------------------------------------
-- Frosty Friday Week 7
-- https://frostyfriday.org/2022/07/29/week-7-intermediate/
------------------------------------------------------------
use role securityadmin;
use database jamielaird;
use schema frosty_friday;

-- Query access history
select *
from snowflake.account_usage.access_history
where user_name = 'JAMIELAIRD'
and date(query_start_time) = current_date();



-- Tag references
select * from snowflake.account_usage.tag_references;

-- Query history
select * from snowflake.account_usage.query_history
where role_name in ('FF_USER1','FF_USER2','FF_USER3')
order by start_time desc;

with tagged_tables as (
    select object_id, object_name
    from snowflake.account_usage.tag_references
    where tag_value = 'Level Super Secret A+++++++'
)
select * from tagged_tables;

61479
56380

with tagged_objects as (
    select
        object_id,
        object_name,
        tag_value
    from snowflake.account_usage.tag_references
    where tag_value = 'Level Super Secret A+++++++'
)
select * from tagged_objects;

with tagged_objects as (
    select
        2348::int as object_id,
        'Made Up Object' as object_name,
        'Made Up Tag' as tag_value
),

queried_objects as (
    select
        -- tag_name
        -- tag_value
        a.query_id,
        bo.value:"objectId"::int as object_id,
        bo.value:"objectName"::varchar as object_name
        -- role_name
    from snowflake.account_usage.access_history a
        ,lateral flatten(a.BASE_OBJECTS_ACCESSED) bo
    where
        bo.value:"objectId"::int in (select * from tagged_objects)
),

tag_name_role as (
    select
        tgo.object_name,
        tgo.tag_value,
        qo.query_id,
        qo.object_id,
        qo.object_name
    from queried_objects qo
    left join tagged_objects tgo
        on qo.object_id = tgo.object_id
)

select * from tag_name_role;


-- Cleanup
use role jamielaird;
drop table if exists week7_villain_information;
drop table if exists week7_monster_information;
drop table if exists week7_weapon_storage_location;
drop tag if exists security_class;

use role securityadmin;
drop role if exists ff_user1;
drop role if exists ff_user2;
drop role if exists ff_user3