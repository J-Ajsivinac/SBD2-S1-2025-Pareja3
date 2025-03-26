
-- Trigger para cargar datos de team_temp a Teams ( Cities y state )

CREATE OR REPLACE TRIGGER trg_team_temp_insert
AFTER INSERT ON temp_team
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
        SELECT id_state INTO v_state_id FROM State WHERE state = :NEW.state AND ROWNUM = 1;
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
            VALUES (state_seq.NEXTVAL, :NEW.state, v_country_id) 
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



-- Trigger para cargar datos de estadium_temp a Estadium

CREATE OR REPLACE TRIGGER trg_team_details_temp_insert
AFTER INSERT ON team_details_temp
FOR EACH ROW
DECLARE
    v_id_estadium NUMBER; -- Variable corregida
BEGIN
    -- Insertar en la tabla estadium
    INSERT INTO estadium (
        name,
        capacity
    ) VALUES (
        :NEW.arena, 
        :NEW.arenacapacity
    );

    -- Obtener el ID del estadio recién insertado
    SELECT id_stadium INTO v_id_estadium
    FROM estadium
    WHERE name = :NEW.arena


    -- Actualizar la tabla Teams con los datos del nuevo equipo
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


-- Trigers para la carga de common_player_info_temp a Players

create or replace TRIGGER trg_CommonPlayerInfo_players
AFTER INSERT OR UPDATE ON temp_CommonPlayerInfo
FOR EACH ROW
DECLARE
    v_id_country NUMBER;
    v_count      NUMBER;
BEGIN
    -- Obtener el id_country si existe
    BEGIN
        SELECT id_country INTO v_id_country
        FROM countries
        WHERE pais = :NEW.COUNTRY
        FETCH FIRST 1 ROWS ONLY;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- Cambiar el id pais
            v_id_country := 75;
    END;

    -- Verificar si el jugador ya existe
    SELECT COUNT(*) INTO v_count 
    FROM players 
    WHERE id_player = :NEW.person_id;

    IF v_count = 0 THEN
        -- Insertar nuevo jugador
        INSERT INTO players (
            id_player,
            full_name,
            first_name,
            last_name,
            is_active,
            birthdate,
            school,
            last_affiliation,
            height,
            weight,
            greatest_75_flag,
            countries_id_country
        ) VALUES (
            :NEW.person_id, 
            :NEW.first_name || ' ' || :NEW.last_name,  
            :NEW.first_name,
            :NEW.last_name,
            0,
            :NEW.birthdate,
            :NEW.school,
            :NEW.last_affiliation,
            :NEW.height,
            :NEW.weight,
            :NEW.greatest_75_flag,
            v_id_country
        );
    ELSE
        -- Actualizar jugador existente
        UPDATE players
        SET
            first_name = :NEW.first_name,
            last_name = :NEW.last_name,
            birthdate = :NEW.birthdate,
            school = :NEW.school,
            last_affiliation = :NEW.last_affiliation,
            height = :NEW.height,
            weight = :NEW.weight,
            greatest_75_flag = :NEW.greatest_75_flag,
            countries_id_country = v_id_country
        WHERE id_player = :NEW.person_id;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Error en el trigger: ' || SQLERRM || ' ID: ' || :NEW.person_id);
END;



-- Triggers para la carga de players 


create or replace TRIGGER trg_insert_players
AFTER INSERT ON temp_player
FOR EACH ROW
BEGIN
    BEGIN
        INSERT INTO players (
            id_player,
            full_name,
            first_name,
            last_name,
            is_active
        ) VALUES (
            :NEW.id, 
            :NEW.full_name,
            :NEW.first_name,
            :NEW.last_name,
            :NEW.is_active
        );
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;  
            RAISE;  
    END;
END;