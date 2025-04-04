CREATE OR REPLACE PROCEDURE buscar_victimas (
    p_equipo_name IN VARCHAR2
)
IS
p_equipo_id integer;
BEGIN
    select id_team into p_equipo_id
    from teams 
    where nickname = p_equipo_name;
    
    -- Mostrar los resultados directamente (modo SQL*Plus o consola)
    FOR r IN (
        SELECT 
            rival_id,
            SUM(puntos) AS puntos_totales,
            SUM(veces_ganadas) AS veces_ganadas
        FROM (
            -- Cuando jugó como visitante
            SELECT 
                teams_id_team1 AS rival_id,
                score_team1 AS puntos,
                CASE 
                    WHEN score_team1 > score_team2 THEN 1
                    ELSE 0
                END AS veces_ganadas
            FROM games
            WHERE teams_id_team = p_equipo_id

            UNION ALL

            -- Cuando jugó como local
            SELECT 
                teams_id_team AS rival_id,
                score_team2 AS puntos,
                CASE 
                    WHEN score_team2 > score_team1 THEN 1
                    ELSE 0
                END AS veces_ganadas
            FROM games
            WHERE teams_id_team1 = p_equipo_id
        )
        GROUP BY rival_id
        ORDER BY puntos_totales DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Rival: ' || r.rival_id || 
                             ' | Puntos: ' || r.puntos_totales || 
                             ' | Victorias: ' || r.veces_ganadas);
    END LOOP;
END;
/

SET SERVEROUTPUT ON;
BEGIN
    buscar_victimas('Lakers');
END;