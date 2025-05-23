        SELECT 
            t.id AS id,
            t.full_name AS nombre_equipo,
            t.nickname AS nick_name,
            td.abbreviation,
            td.yearfounded ,
            td.arena,
            td.arenacapacity,
            td.headcoach,
            td.owner,
            td.generalmanager ,
            td.dleagueaffiliation,
            td.facebook,
            td.instagram,
            td.twitter,
            COUNT(*) AS wins
        FROM (
            SELECT
                CASE
                    WHEN pts_home > pts_away THEN team_id_home 
                    WHEN pts_away > pts_home THEN team_id_away 
                    ELSE NULL
                END AS team_name
            FROM game
        ) victorias
        INNER JOIN team t ON t.id = victorias.team_name
        INNER JOIN team_details td ON  td.team_id = t.id
        GROUP BY t.id, t.full_name, t.nickname	
        ORDER BY wins DESC;