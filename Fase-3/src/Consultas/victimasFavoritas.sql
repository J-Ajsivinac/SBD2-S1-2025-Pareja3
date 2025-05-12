SELECT 
    CASE 
        WHEN wl_home = 'W' THEN team_name_home
        WHEN wl_away = 'W' THEN team_name_away
    END AS equipo,
    CASE 
	    WHEN wl_home = 'W' THEN team_name_away
	    WHEN wl_away = 'W' THEN team_name_home
    END AS equipo_victima,
    COUNT(*) AS victorias
FROM 
    game
GROUP BY 
    equipo, equipo_victima
ORDER BY 
    victorias DESC;
