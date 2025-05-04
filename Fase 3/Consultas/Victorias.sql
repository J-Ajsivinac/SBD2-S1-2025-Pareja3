SELECT 
    t.id AS id,
    t.full_name AS nombre_equipo,
    t.nickname AS nick_name,
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
GROUP BY t.id, t.full_name, t.nickname	
ORDER BY wins DESC;
