CREATE OR REPLACE TRIGGER trg_inactive_players
AFTER INSERT ON inactive_players_temp
FOR EACH ROW

DECLARE
    existing_player INTEGER;
    v_team_id NUMBER;
BEGIN
    -- Obtener o crear el team, devuelve su ID
    v_team_id := get_or_create_team(:NEW.team_abbreviation, :NEW.team_id);

    -- Verifica si el jugador ya existe
    SELECT COUNT(*) INTO existing_player 
    FROM players 
    WHERE id_player = :NEW.player_id;

    IF existing_player = 0 THEN
        -- Insertar en players
        INSERT INTO players (
            id_player,
            full_name,
            first_name,
            last_name,
            is_active
        ) VALUES (
            :NEW.player_id, 
            :NEW.first_name || ' ' || :NEW.last_name,  
            :NEW.first_name,
            :NEW.last_name,
            0
        );
    END IF;

    -- Insertar en inactive_players
    INSERT INTO inactive_players (
        PLAYERS_ID_PLAYER,
        jersey_num,
        teams_id_team
    ) VALUES (
        :NEW.player_id, 
        :NEW.jersey_num, 
        v_team_id
    );
END;
/
