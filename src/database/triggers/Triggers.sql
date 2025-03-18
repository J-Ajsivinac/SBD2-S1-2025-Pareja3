CREATE SEQUENCE city_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE estadium_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE state_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE countries_seq START WITH 1 INCREMENT BY 1;

-- Trigger para cargar datos de team_temp a Teams ( Cities y state )
CREATE OR REPLACE TRIGGER trg_team_temp_insert
AFTER INSERT ON team_temp
FOR EACH ROW
DECLARE
    v_city_id INTEGER;
    v_stadium_id INTEGER;
    v_state_id INTEGER;
    v_country_id INTEGER;
BEGIN
    -- Buscar o crear la ciudad
    BEGIN
        SELECT id_city INTO v_city_id FROM Cities WHERE city = :NEW.city AND ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO Cities (id_city, city) 
            VALUES (city_seq.NEXTVAL, :NEW.city) 
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
        SELECT id_state INTO v_state_id FROM State WHERE state = :NEW.state_ AND ROWNUM = 1;
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
            VALUES (state_seq.NEXTVAL, :NEW.state_, v_country_id) 
            RETURNING id_state INTO v_state_id;
    END;
    
    -- Insertar el equipo
    INSERT INTO Teams (
        id_team,
        full_name,
        abbreviation,
        nickname,
        year_founded,
        Cities_id_city,
        Estadium_id_stadium,
        State_id_state
    ) VALUES (
        TO_NUMBER(:NEW.id),
        :NEW.full_name,
        :NEW.abbreviation,
        :NEW.nickname,
        :NEW.year_founded,
        v_city_id,
        v_stadium_id,
        v_state_id
    );
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        NULL; -- Ignorar duplicados
    WHEN OTHERS THEN
        RAISE;
END;
/


CREATE OR REPLACE TRIGGER trg_team_details_temp_insert
AFTER INSERT ON team_details_temp
FOR EACH ROW
BEGIN
    -- Actualizar información adicional del equipo
    UPDATE Teams
    SET owner = :NEW.owner,
        generalManager = :NEW.generalmanager,
        headcoach = :NEW.headcoach,
        dleagueaffiliation = :NEW.dleagueaffiliation,
        facebook = :NEW.facebook,
        instagram = :NEW.instagram,
        twitter = :NEW.twitter
    WHERE id_team = :NEW.team_id;
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END;
/

-- Trigger para cargar datos de team_history_temp a History
CREATE OR REPLACE TRIGGER trg_team_history_temp_insert
AFTER INSERT ON team_history_temp
FOR EACH ROW
BEGIN
    INSERT INTO History (
        Teams_id_team,
        nickname,
        city,
        year_founded,
        year_active_till
    ) VALUES (
        TO_NUMBER(:NEW.team_id),
        :NEW.nickname,
        :NEW.city,
        :NEW.year_founded,
        :NEW.year_active_till
    );
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        NULL; -- Ignorar duplicados
    WHEN OTHERS THEN
        RAISE;
END;
/

-- TODO: Trigger para cargar datos de game_temp a Games 