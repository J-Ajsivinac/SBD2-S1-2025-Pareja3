OPTIONS (SKIP=1)
LOAD DATA
INFILE *
INTO TABLE team_temp
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
    id,
    full_name,
    abbreviation,
    nickname,
    city,
    state_,
    year_founded "TO_NUMBER(REPLACE(:year_founded, '.0', ''),9999)"
)