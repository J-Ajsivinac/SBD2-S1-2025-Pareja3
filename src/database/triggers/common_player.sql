create or replace TRIGGER trg_CommonPlayerInfo_players
AFTER INSERT OR UPDATE ON common_player_info_temp
FOR EACH ROW
DECLARE
    v_id_country NUMBER;
    v_count      NUMBER;
BEGIN
    -- Intentar obtener el ID del país
    BEGIN
        SELECT id_country INTO v_id_country
        FROM countries 
        WHERE pais = :NEW.country
        AND ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- Insertar nuevo país si no existe
            INSERT INTO countries (id_country, pais)
            VALUES (paises.NEXTVAL, :NEW.country)
            RETURNING id_country INTO v_id_country;
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
            3,
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
        RAISE_APPLICATION_ERROR(
            -20002,
            'Error en el trigger: ' || SQLERRM || 
            ' | ID: ' || :NEW.person_id || 
            ' | PAIS: ' || :NEW.COUNTRY
        );
END;
/