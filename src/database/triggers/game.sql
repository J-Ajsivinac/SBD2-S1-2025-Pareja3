CREATE OR REPLACE TRIGGER trg_game_temp_insert
AFTER INSERT ON game_temp
FOR EACH ROW
DECLARE
    v_season_id INTEGER;
    v_home_team_id INTEGER;
    v_away_team_id INTEGER;
    v_season_start_date DATE;
    v_season_end_date DATE;
BEGIN
    -- Buscar o crear la temporada
    BEGIN
        SELECT id_season INTO v_season_id 
        FROM Season 
        WHERE id_season = :NEW.season_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- Calcular fechas de inicio y fin de la temporada
            INSERT INTO Season (
                id_season, 
                season_date_o, 
                season_date_f, 
                season_type
            ) VALUES (
                :NEW.season_id, 
                :NEW.game_date, -- 1 de enero del año actual
                :NEW.game_date, -- 31 de diciembre del año actual
                :NEW.season_type
            );
            
            v_season_id := :NEW.season_id;
    END;
    
    -- Obtener o crear los equipos y sus IDs
    v_home_team_id := get_or_create_team(:NEW.team_abbreviation_home, :NEW.team_id_home);
    v_away_team_id := get_or_create_team(:NEW.team_abbreviation_away, :NEW.team_id_away);
    
    -- Insertar el juego
    INSERT INTO Games (
        id_game,
        game_date,
        Teams_id_team,
        Teams_id_team1,
        Score_team1,
        score_team2,
        game_sequence,
        game_status_id,
        Season_id_season,
        live_period,
        live_p_t_bcast,
        wh_status
    ) VALUES (
        TO_NUMBER(:NEW.game_id),
        :NEW.game_date,
        v_home_team_id,  -- Usar el ID obtenido/creado
        v_away_team_id,  -- Usar el ID obtenido/creado
        :NEW.pts_home,
        :NEW.pts_away,
        1, -- Valor por defecto para game_sequence
        1, -- Valor por defecto para game_status_id
        v_season_id,
        1, -- Valor por defecto para live_period
        'N/A', -- Valor por defecto para live_p_t_bcast
        1  -- Valor por defecto para wh_status
    );
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        NULL; -- Ignorar duplicados
    WHEN OTHERS THEN
        -- Registrar el error para diagnóstico
        DBMS_OUTPUT.PUT_LINE('Error al insertar juego: ' || SQLERRM);
        RAISE;
END;
/


CREATE OR REPLACE PROCEDURE update_all_season_dates AS
BEGIN
    -- Actualizar fechas de inicio y fin de TODAS las temporadas en un solo paso
    UPDATE Season s
    SET (season_date_o, season_date_f) = (
        SELECT MIN(game_date), MAX(game_date)
        FROM game_temp g
        WHERE g.season_id = s.id_season
    )
    WHERE EXISTS (
        SELECT 1 FROM game_temp g WHERE g.season_id = s.id_season
    );

    COMMIT;
END;
/

-- Usar el procedure
BEGIN update_all_season_dates; END;
/