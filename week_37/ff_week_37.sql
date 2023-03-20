------------------------------------------------------------
-- Frosty Friday Week 37
-- https://frostyfriday.org/2023/03/10/week-37-intermediate/
------------------------------------------------------------
use role accountadmin;
use database jamielaird;
use schema frosty_friday;

------------------------------------------------------------
-- Startup Code
------------------------------------------------------------
create or replace storage integration week37_si
    type = external_stage
    storage_provider = 's3'
    storage_aws_role_arn = 'arn:aws:iam::184545621756:role/week37'
    enabled = true
    storage_allowed_locations = ('s3://frostyfridaychallenges/challenge_37/');

------------------------------------------------------------
-- Solution
------------------------------------------------------------
create or replace stage week37_stage
    url = 's3://frostyfridaychallenges/challenge_37/'
    storage_integration = week37_si
    directory = (
        enable = true
        refresh_on_create = true
    );

select
    relative_path,
    file_url,
    build_scoped_file_url(@week37_stage, relative_path) as scoped_file_url,
    build_stage_file_url(@week37_stage, relative_path) as stage_file_url,
    get_presigned_url(@week37_stage, relative_path, 100) as presigned_url
from directory(@week37_stage);

------------------------------------------------------------
-- Cleanup
------------------------------------------------------------
drop storage integration if exists week37_si;
drop stage if exists week37_si;