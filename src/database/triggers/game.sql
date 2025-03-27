CREATE OR REPLACE TRIGGER trg_game_temp_insert
AFTER INSERT ON game_temp
FOR EACH ROW
DECLARE
    v_season_id INTEGER;
    v_home_team_id INTEGER;
    v_away_team_id INTEGER;
    v_season_start_date DATE;
    v_season_end_date DATE;

    -- Función para obtener o insertar un equipo y devolver su ID
    FUNCTION get_or_create_team(p_abbreviation VARCHAR2, p_id_team NUMBER) RETURN NUMBER IS
        v_team_id NUMBER;
        v_city_id INTEGER;
        v_stadium_id INTEGER;
        v_state_id INTEGER;
        v_country_id INTEGER;
    BEGIN
        BEGIN
            -- Intentar encontrar el equipo existente por ID o abreviatura
            SELECT id_team INTO v_team_id 
            FROM Teams 
            WHERE id_team = p_id_team OR abbreviation = p_abbreviation
            ORDER BY CASE WHEN id_team = p_id_team THEN 0 ELSE 1 END
            FETCH FIRST 1 ROW ONLY;
            
            RETURN v_team_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- Buscar o crear la ciudad
                BEGIN
                    SELECT id_city INTO v_city_id FROM Cities WHERE city = 'Unknown' AND ROWNUM = 1;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        INSERT INTO Cities (id_city, city) 
                        VALUES (city_seq.NEXTVAL, 'Unknown') 
                        RETURNING id_city INTO v_city_id;
                END;
                
                -- Buscar o crear el estadio
                BEGIN
                    SELECT id_stadium INTO v_stadium_id FROM Estadium WHERE name = 'Unknown' AND ROWNUM = 1;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        INSERT INTO Estadium (id_stadium, name, capacity) 
                        VALUES (estadium_seq.NEXTVAL, 'Unknown', 0) 
                        RETURNING id_stadium INTO v_stadium_id;
                END;
                
                -- Buscar o crear el estado
                BEGIN
                    SELECT id_state INTO v_state_id FROM State WHERE state = 'Unknown' AND ROWNUM = 1;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        -- Intentar obtener un país existente o crearlo
                        BEGIN
                            SELECT id_country INTO v_country_id FROM Countries WHERE pais = 'Unknown' AND ROWNUM = 1;
                        EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                                INSERT INTO Countries (id_country, pais) 
                                VALUES (countries_seq.NEXTVAL, 'Unknown') 
                                RETURNING id_country INTO v_country_id;
                        END;
                        
                        INSERT INTO State (id_state, state, Countries_id_country) 
                        VALUES (state_seq.NEXTVAL, 'Unknown', v_country_id) 
                        RETURNING id_state INTO v_state_id;
                END;
                
                -- Insertar el equipo usando el ID proporcionado
                INSERT INTO Teams (
                    id_team, 
                    abbreviation, 
                    full_name,
                    nickname,
                    Cities_id_city,
                    Estadium_id_stadium,
                    State_id_state,
                    year_founded
                ) VALUES (
                    p_id_team,
                    p_abbreviation,
                    p_abbreviation || ' Team',  -- Nombre completo temporal
                    p_abbreviation,  -- Apodo temporal
                    v_city_id,
                    v_stadium_id,
                    v_state_id,
                    EXTRACT(YEAR FROM SYSDATE))
                RETURNING id_team INTO v_team_id;
                
                RETURN v_team_id;
        END;
    END get_or_create_team;
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