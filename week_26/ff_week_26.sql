------------------------------------------------------------
-- Frosty Friday Week 26
-- https://frostyfriday.org/2022/12/09/week-26-intermediate/
------------------------------------------------------------
use role jamielaird;
use database jamielaird;
use schema frosty_friday;

------------------------------------------------------------
-- TASK 1
------------------------------------------------------------
-- Create table to store timestamps
create or replace table ff_timestamps (
    id int identity not null,
    timestamp timestamp_ntz not null
);

-- Create task to record timestamp every 5 minutes
create or replace task ff_log_timestamp
    warehouse = jamielaird
    schedule = 'USING CRON */5 * * * * UTC'
as
insert into ff_timestamps (timestamp) select current_timestamp();

-- Resume task
alter task ff_log_timestamp resume;

-- Check task status
show tasks;

-- Check timestamp table
select * from ff_timestamps;

-- Suspend task
alter task ff_log_timestamp suspend;

------------------------------------------------------------
-- TASK 2
------------------------------------------------------------
-- Create notification integration
use role accountadmin;
create or replace notification integration ff_email_int
    type = email
    enabled = true
    allowed_recipients = ('jamie.laird@aimpointdigital.com');

-- Grant permission to own role
grant usage on integration ff_email_int to role jamielaird;

-- Switch to own role
use role jamielaird;

-- Create task to send email after Task 1
create or replace task ff_email_notification
    warehouse = jamielaird
    after ff_log_timestamp
as
call system$send_email (
    'ff_email_int',
    'jamie.laird@aimpointdigital.com',
    'Email Alert: Task has finished',
    'Task has successfully finished on '||current_account()||' which is deployed on '||current_region() ||' at '||current_timestamp()
);

-- Resume both tasks, starting with dependent task
alter task ff_email_notification resume;
alter task ff_log_timestamp resume;

-- Check table
select * from ff_timestamps;

-- Check tasks
show tasks;

------------------------------------------------------------
-- CLEANUP
------------------------------------------------------------
use role jamielaird;
alter task if exists ff_log_timestamp suspend;
alter task if exists ff_email_notification suspend;
drop task if exists ff_log_timestamp;
drop task if exists ff_email_notification;
drop table if exists ff_timestamps;

use role accountadmin;
drop notification integration if exists ff_email_int;

------------------------------------------------------------
-- RESOURCES
------------------------------------------------------------
-- https://docs.snowflake.com/en/sql-reference/sql/create-task.html
-- https://cronprompt.com/
-- https://docs.snowflake.com/en/user-guide/email-stored-procedures.html
-- https://medium.com/snowflake/%EF%B8%8F-snowflake-in-a-nutshell-email-notifications-98c85471b5a1