CREATE OR REPLACE PROCEDURE Insert_Play_by_Play_Player(
    p_player_id VARCHAR2,
    p_game_id VARCHAR2,
    p_person_type NUMBER,
    p_play_id NUMBER,
    player_number NUMBER
) AS
    v_player_id INTEGER;
BEGIN
    IF p_player_id IS NOT NULL AND TO_NUMBER(p_player_id) > 0 THEN
        BEGIN
            SELECT id_player INTO v_player_id 
            FROM Players 
            WHERE id_player = TO_NUMBER(p_player_id);
                        
            -- Insertar en Play_by_play_Players con ID generado por la secuencia
            INSERT INTO pbp_Players (
                id_pbp_player,
                person_type,
                Players_id_player,
                Play_by_play_Play_by_play_ID,
                pbp_game_id,
                player_num
            ) VALUES (
                seq_pbp_player_id.NEXTVAL, -- Se obtiene el siguiente valor de la secuencia
                p_person_type,
                v_player_id,
                p_play_id,
                p_game_id,
                player_number
            );

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL; -- No insertar si no existe el jugador
        END;
    END IF;
END;
/