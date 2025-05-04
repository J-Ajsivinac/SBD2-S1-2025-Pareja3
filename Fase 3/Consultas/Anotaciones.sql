WITH
    PuntosMaximos AS (
        SELECT
            player1_id,
            player1_name,
            game_id,
            MAX(
                CASE
                    WHEN homedescription LIKE '%PTS%' THEN CAST(
                        SUBSTR (
                            homedescription,
                            INSTR (homedescription, '(') + 1,
                            INSTR (homedescription, ' PTS)') - INSTR (homedescription, '(') - 1
                        ) AS INTEGER
                    )
                    WHEN visitordescription LIKE '%PTS%' THEN CAST(
                        SUBSTR (
                            visitordescription,
                            INSTR (visitordescription, '(') + 1,
                            INSTR (visitordescription, ' PTS)') - INSTR (visitordescription, '(') - 1
                        ) AS INTEGER
                    )
                    ELSE 0
                END
            ) AS puntos_en_juego
        FROM
            play_by_play
        WHERE
            homedescription LIKE '%PTS%'
            OR visitordescription LIKE '%PTS%'
        GROUP BY
            player1_id,
            player1_name,
            game_id
    )
SELECT
    player1_id,
    player1_name,
    cpi.birthdate,
    cpi.country ,
    cpi.school,
    cpi.height ,
	cpi.weight ,
	cpi."position" ,
	cpi.jersey ,
	cpi.player_slug,
	cpi.season_exp ,
	cpi.draft_year ,
	cpi.draft_number ,
	t.full_name ,
	t.nickname ,
	t.abbreviation ,
	t.state ,
	t.city ,
    COUNT(DISTINCT game_id) AS juegos_con_puntos,
    SUM(puntos_en_juego) AS puntos_totales
FROM
    PuntosMaximos
 LEFT JOIN common_player_info cpi on cpi.person_id = player1_id 
 LEFT JOIN team t ON t.id = cpi.team_id
 GROUP BY
    player1_id,
    player1_name
 order by puntos_totales desc;




