OPTIONS (SKIP=1)
LOAD DATA
INFILE 'team_details.csv'
INTO TABLE team_details_temp
APPEND
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'  AND '"'
TRAILING NULLCOLS
(
    team_id INTEGER EXTERNAL,
    abbreviation CHAR,
    nickname CHAR,
    yearfounded,
    city CHAR,
    arena CHAR,
    arenacapacity CHAR,
    owner CHAR,
    generalmanager CHAR,
    headcoach CHAR,
    dleagueaffiliation CHAR,
    facebook CHAR,
    instagram CHAR,
    twitter CHAR
)