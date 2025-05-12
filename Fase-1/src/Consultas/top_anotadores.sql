WITH PuntosMaximos AS (
    SELECT 
        p.id_player AS player_id,
        p.full_name AS player_name,
        pbp.Games_id_game AS game_id,
        MAX(
            CASE 
                WHEN pbp.homedescription LIKE '%PTS%' THEN 
                    TO_NUMBER(
                        SUBSTR(
                            pbp.homedescription, 
                            INSTR(pbp.homedescription, '(') + 1, 
                            INSTR(pbp.homedescription, ' PTS)') - INSTR(pbp.homedescription, '(') - 1
                        )
                    )
                WHEN pbp.visitordescription LIKE '%PTS%' THEN 
                    TO_NUMBER(
                        SUBSTR(
                            pbp.visitordescription, 
                            INSTR(pbp.visitordescription, '(') + 1, 
                            INSTR(pbp.visitordescription, ' PTS)') - INSTR(pbp.visitordescription, '(') - 1
                        )
                    )
                ELSE 0
            END
        ) AS puntos_en_juego
    FROM 
        Play_by_play pbp
        JOIN pbp_players pp ON pp.Play_by_play_Play_by_play_ID = pbp.Play_by_play_ID AND pp.player_num = 1
        JOIN Players p ON p.id_player = pp.Players_id_player 
    WHERE 
        pbp.homedescription LIKE '%PTS%' 
        OR pbp.visitordescription LIKE '%PTS%'
    GROUP BY 
        p.id_player, p.full_name, pbp.Games_id_game
)
SELECT 
    player_id, 
    player_name, 
    COUNT(DISTINCT game_id) AS juegos_con_puntos,
    SUM(puntos_en_juego) AS puntos_totales
FROM 
    PuntosMaximos
GROUP BY 
    player_id, player_name
ORDER BY 
    puntos_totales DESC
    FETCH FIRST 10 ROWS ONLY;
/