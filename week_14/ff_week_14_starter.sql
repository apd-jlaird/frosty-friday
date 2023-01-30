------------------------------------------------------------
-- Frosty Friday Week 14 - Starter Code
------------------------------------------------------------
use role jamielaird;
use database jamielaird;
use schema frosty_friday;

CREATE OR REPLACE TABLE ff_week_14 (
    superhero_name varchar(50),
    country_of_residence varchar(50),
    notable_exploits varchar(150),
    superpower varchar(100),
    second_superpower varchar(100),
    third_superpower varchar(100)
);

INSERT INTO ff_week_14 VALUES ('Superpig', 'Ireland', 'Saved head of Irish Farmer\'s Association from terrorist cell', 'Super-Oinks', NULL, NULL);
INSERT INTO ff_week_14 VALUES ('Señor Mediocre', 'Mexico', 'Defeated corrupt convention of fruit lobbyists by telling anecdote that lasted 33 hours, with 16 tangents that lead to 17 resignations from the board', 'Public speaking', 'Stamp collecting', 'Laser vision');
INSERT INTO ff_week_14 VALUES ('The CLAW', 'USA', 'Horrifically violent duel to the death with mass murdering super villain accidentally created art installation last valued at $14,450,000 by Sotheby\'s', 'Back scratching', 'Extendable arms', NULL);
INSERT INTO ff_week_14 VALUES ('Il Segreto', 'Italy', NULL, NULL, NULL, NULL);
INSERT INTO ff_week_14 VALUES ('Frosty Man', 'UK', 'Rescued a delegation of data engineers from a DevOps conference', 'Knows, by memory, 15 definitions of an obscure codex known as "the data mesh"', 'can copy and paste from StackOverflow with the blink of an eye', NULL);