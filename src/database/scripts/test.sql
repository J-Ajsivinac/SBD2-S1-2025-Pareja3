SELECT * FROM COMMON_PLAYER_INFO_TEMP;

SELECT * FROM team_details_temp;

SELECT id_player, COUNT(*)
FROM players
GROUP BY id_player
HAVING COUNT(*) > 1;

SELECT * FROM dba_sys_privs WHERE grantee = 'BD2_FASE1' AND privilege = 'UNLIMITED TABLESPACE';


INSERT INTO team_details_temp (
    team_id, abbreviation, nickname, yearfounded, city, arena, arenacapacity, owner, generalmanager, headcoach, dleagueaffiliation, facebook, instagram, twitter
) VALUES (
    'T001', 'LAL', 'Lakers', 1947.0, 'Los Angeles', 'Crypto.com Arena', 19068, 'Jeanie Buss', 'Rob Pelinka', 'Darvin Ham', 'South Bay Lakers', 'https://facebook.com/lakers', 'https://instagram.com/lakers', 'https://twitter.com/lakers'
);

INSERT INTO team_temp (id, full_name, abbreviation, nickname, city, state_, year_founded)
VALUES ('1', 'Los Angeles Lakers', 'LAL', 'Lakers', 'Los Angeles', 'California', 1947.0);

SELECT * FROM TEAM_DETAILS_TEMP;
SELECT * FROM TEAM_TEMP;
SELECT * FROM COUNTRIES;
SELECT * FROM CITIES;
SELECT * FROM STATE;
SELECT * FROM ESTADIUM;
SELECT * FROM TEAMS;
SELECT * FROM HISTORY;
