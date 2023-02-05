------------------------------------------------------------
-- Frosty Friday Week 32
-- https://frostyfriday.org/2023/02/03/week-32-basic/
------------------------------------------------------------
use database jamielaird;
use schema frosty_friday;

-- Create policy admin role
use role useradmin;
create role policy_admin;
grant role policy_admin to user jamielaird;

-- Grant privileges to policy admin
use role securityadmin;
grant usage on database jamielaird to role policy_admin;
grant usage, create session policy on schema jamielaird.frosty_friday to role policy_admin;
grant apply session policy on account to role policy_admin;

-- Create users
use role securityadmin;

create or replace user ff_ui_user;
create or replace user ff_non_ui_user;

-- Grant on users
grant apply session policy on user ff_ui_user to role policy_admin;
grant apply session policy on user ff_non_ui_user to role policy_admin;

-- Create a new session policy for UI users
use role policy_admin;

create or replace session policy jamielaird.frosty_friday.session_policy_ui_user
    session_ui_idle_timeout_mins = 8;

-- Create a session policy for non-UI users
use role policy_admin;

create or replace session policy jamielaird.frosty_friday.session_policy_non_ui_user
    session_idle_timeout_mins = 10;

-- Show session policies
show session policies;

-- Set session policy for ui user
use role policy_admin;
alter user ff_ui_user set session policy jamielaird.frosty_friday.session_policy_ui_user;

-- Set session policy for non-UI user
use role policy_admin;
alter user ff_non_ui_user set session policy session_policy_non_ui_user;

-- Cleanup
use role securityadmin;
drop user ff_ui_user;
drop user ff_non_ui_user;

use role policy_admin;
drop session policy jamielaird.frosty_friday.session_policy_ui_user;
drop session policy jamielaird.frosty_friday.session_policy_non_ui_user;


-- Docs
-- https://docs.snowflake.com/en/user-guide/session-policies.html#step-6-replicate-the-session-policy-to-a-target-account