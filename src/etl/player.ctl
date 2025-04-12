OPTIONS (SKIP=1)
LOAD DATA
INFILE *
INTO TABLE player_temp
APPEND
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'  AND '"'
TRAILING NULLCOLS
(
    id,
    full_name,
    first_name,
    last_name,
    is_active 
)