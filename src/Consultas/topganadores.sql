SELECT 
    equipo AS equipo_id,
    COUNT(*) AS victorias_totales
FROM (
    -- Partidos donde el equipo fue local y ganó
    SELECT 
        teams_id_team1 AS equipo
    FROM games
    WHERE score_team1 > score_team2

    UNION ALL

    -- Partidos donde el equipo fue visitante y ganó
    SELECT 
        teams_id_team AS equipo
    FROM games
    WHERE score_team2 > score_team1
)
GROUP BY equipo
ORDER BY victorias_totales DESC
FETCH FIRST 10 ROWS ONLY;
