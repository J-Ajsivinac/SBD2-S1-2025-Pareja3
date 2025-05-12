OPTIONS (SKIP=1)
LOAD DATA
INFILE 'team_history.csv'
INTO TABLE team_history_temp
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
    team_id,
    city,
    nickname,
    year_founded,
    year_active_till
)