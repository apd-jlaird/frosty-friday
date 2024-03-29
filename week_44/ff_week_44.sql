------------------------------------------------------------
-- Frosty Friday Week 44
-- https://frostyfriday.org/2023/05/05/week-44-basic/
------------------------------------------------------------
use role jamielaird;
use database jamielaird;
use schema frosty_friday;

------------------------------------------------------------
-- Startup Code
------------------------------------------------------------
-- Mock Data
create table MOCK_DATA (
id INT,
salary INT,
teamnumber INT
);
insert into MOCK_DATA (id, salary, teamnumber) values (1, 781767, 2);
insert into MOCK_DATA (id, salary, teamnumber) values (2, 701047, 5);
insert into MOCK_DATA (id, salary, teamnumber) values (3, 348497, 2);
insert into MOCK_DATA (id, salary, teamnumber) values (4, 555275, 2);
insert into MOCK_DATA (id, salary, teamnumber) values (5, 144962, 3);
insert into MOCK_DATA (id, salary, teamnumber) values (6, 832979, 4);
insert into MOCK_DATA (id, salary, teamnumber) values (7, 387404, 1);
insert into MOCK_DATA (id, salary, teamnumber) values (8, 427563, 3);
insert into MOCK_DATA (id, salary, teamnumber) values (9, 788928, 3);
insert into MOCK_DATA (id, salary, teamnumber) values (10, 257613, 1);
insert into MOCK_DATA (id, salary, teamnumber) values (11, 483792, 4);
insert into MOCK_DATA (id, salary, teamnumber) values (12, 720679, 3);
insert into MOCK_DATA (id, salary, teamnumber) values (13, 452976, 4);
insert into MOCK_DATA (id, salary, teamnumber) values (14, 541193, 2);
insert into MOCK_DATA (id, salary, teamnumber) values (15, 159377, 1);
insert into MOCK_DATA (id, salary, teamnumber) values (16, 825003, 4);
insert into MOCK_DATA (id, salary, teamnumber) values (17, 362209, 3);
insert into MOCK_DATA (id, salary, teamnumber) values (18, 291622, 5);
insert into MOCK_DATA (id, salary, teamnumber) values (19, 646774, 3);
insert into MOCK_DATA (id, salary, teamnumber) values (20, 971930, 1);

CREATE OR REPLACE ROW ACCESS POLICY demo_policy
AS (teamnumber int) RETURNS BOOLEAN ->
CURRENT_ROLE() = 'HR'
OR LEFT(CURRENT_ROLE(),13) = 'MANAGER_TEAM_' AND RIGHT(CURRENT_ROLE(),1) = RIGHT(teamnumber, 1);

alter table MOCK_DATA add row access policy demo_policy on (teamnumber);

-- "The Hack"
CREATE OR REPLACE PROCEDURE totally_not_a_suspicious_procedure()
RETURNS VARCHAR
LANGUAGE JAVASCRIPT
AS
$$
var stmt = snowflake.createStatement({
sqlText: "alter table MOCK_DATA drop row access policy demo_policy;"
});
stmt.execute();
return "Row access policy dropped successfully.";
$$;

CALL totally_not_a_suspicious_procedure();

select * from MOCK_DATA;

CREATE OR REPLACE PROCEDURE totally_not_a_suspicious_procedure2()
RETURNS VARCHAR
LANGUAGE JAVASCRIPT
AS
$$
var stmt = snowflake.createStatement({
sqlText: "alter table MOCK_DATA add row access policy demo_policy on (teamnumber);;"
});
stmt.execute();
return "Row access policy dropped successfully.";
$$;

CALL totally_not_a_suspicious_procedure2();

drop procedure totally_not_a_suspicious_procedure();
drop procedure totally_not_a_suspicious_procedure2();

------------------------------------------------------------
-- Solution
------------------------------------------------------------
SELECT
  POLICY_NAME,
  CREATED,
  MODIFIED,
  POLICY_DEFINITIONS
FROM
  jamielaird.INFORMATION_SCHEMA.POLICIES
ORDER BY
  MODIFIED DESC;



select distinct granted_to_role
from information_schema.row_access_policies;

use role accountadmin;

select *
from information_schema.row_access_policies
where created_on >= dateadd('day', -14, current_date());

------------------------------------------------------------
-- Cleanup
------------------------------------------------------------

------------------------------------------------------------
-- References
------------------------------------------------------------