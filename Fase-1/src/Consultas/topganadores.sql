SELECT 
    t.id_team as id,
    t.full_name AS nombre_equipo,
    t.nickname AS nick_name,
    COUNT(*) AS wins
FROM (
    SELECT
        CASE
            WHEN score_team1 > score_team2 THEN teams_id_team
            WHEN score_team2 > score_team1 THEN teams_id_team1
            ELSE NULL
        END AS team_name
    FROM games
) victorias
INNER JOIN teams t ON t.id_team = victorias.team_name
GROUP BY t.id_team, t.full_name, t.nickname
ORDER BY wins DESC
FETCH FIRST 10 ROWS ONLY;