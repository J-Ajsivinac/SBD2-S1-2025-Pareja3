WITH PuntosMaximos AS (
    SELECT
    player1_id,
    player1_name,
    game_id,
    MAX(
    CASE
    WHEN homedescription LIKE '%PTS%' THEN
    CAST(
    SUBSTR(
    homedescription,
    INSTR(homedescription, '(') + 1,
    INSTR(homedescription, ' PTS)') - INSTR(homedescription, '(') - 1
    ) AS INTEGER
    )
    WHEN visitordescription LIKE '%PTS%' THEN
    CAST(
    SUBSTR(
    visitordescription,
    INSTR(visitordescription, '(') + 1,
    INSTR(visitordescription, ' PTS)') - INSTR(visitordescription, '(') - 1
    ) AS INTEGER
    )
    ELSE 0
    END
    ) AS puntos_en_juego
    FROM play_by_play
    WHERE homedescription LIKE '%PTS%' OR visitordescription LIKE '%PTS%'
    GROUP BY player1_id, player1_name, game_id
    )
    SELECT
    player1_id,
    player1_name,
    COUNT(DISTINCT game_id) AS juegos_con_puntos,
    SUM(puntos_en_juego) AS puntos_totales
    FROM PuntosMaximos
    GROUP BY player1_id,player1_name