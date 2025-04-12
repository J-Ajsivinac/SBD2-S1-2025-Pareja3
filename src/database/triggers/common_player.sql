CREATE OR REPLACE TRIGGER trg_CommonPlayerInfo_players
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
            countries_id_country,
            player_slug,
            season_exp,
            jersey,
            position,
            rosterstatus,
            games_played_current_season_flag,
            from_year,
            to_year,
            dleague_flag,
            nba_flag,
            games_played_flag,
            draft_year,
            draft_round,
            draft_number
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
            v_id_country,
            :NEW.player_slug,  -- Faltaba el :NEW aquí
            :NEW.season_exp,
            :NEW.jersey,
            :NEW.position_,     -- Ahora en minúsculas
            :NEW.rosterstatus,
            :NEW.games_played_current_season_flag,
            TO_NUMBER(:NEW.from_year),
            TO_NUMBER(:NEW.to_year),
            :NEW.dleague_flag,
            :NEW.nba_flag,
            :NEW.games_played_flag,
            :NEW.draft_year,
            :NEW.draft_round,
            :NEW.draft_number
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
            countries_id_country = v_id_country,
            player_slug=:NEW.player_slug,  -- Faltaba el :NEW aquí
            season_exp=:NEW.season_exp,
            jersey=:NEW.jersey,
            position=:NEW.position_,     -- Ahora en minúsculas
            rosterstatus=:NEW.rosterstatus,
            games_played_current_season_flag=:NEW.games_played_current_season_flag,
            from_year=TO_NUMBER(:NEW.from_year),
            to_year=TO_NUMBER(:NEW.to_year),
            dleague_flag=:NEW.dleague_flag,
            nba_flag=:NEW.nba_flag,
            games_played_flag=:NEW.games_played_flag,
            draft_year=:NEW.draft_year,
            draft_round=:NEW.draft_round,
            draft_number=:NEW.draft_number
        WHERE id_player = :NEW.person_id;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(
            -20002,
            'Error en el trigger: ' || SQLERRM || 
            ' | ID: ' || :NEW.person_id || 
            ' | PAIS: ' || :NEW.country
        );
END;
/