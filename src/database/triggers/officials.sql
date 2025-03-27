-- Trigger para cargar datos de officials_temp a Officials
CREATE OR REPLACE TRIGGER trg_officials_temp_insert
AFTER INSERT ON officials_temp
FOR EACH ROW
BEGIN
    -- Insertar el oficial
    INSERT INTO Officials (
        id_official,
        first_name,
        last_name,
        jersey_num
    ) VALUES (
        TO_NUMBER(:NEW.official_id),
        :NEW.first_name,
        :NEW.last_name,
        TO_NUMBER(:NEW.jersey_num)
    );
    
    -- Relacionar el oficial con el juego
    INSERT INTO Game_officials (
        jersey_num,
        Games_id_game,
        Officials_id_official
    ) VALUES (
        TO_NUMBER(:NEW.jersey_num),
        TO_NUMBER(:NEW.game_id),
        TO_NUMBER(:NEW.official_id)
    );
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        -- Si el oficial ya existe, solo crear la relación con el juego
        INSERT INTO Game_officials (
            jersey_num,
            Games_id_game,
            Officials_id_official
        ) VALUES (
            TO_NUMBER(:NEW.jersey_num),
            TO_NUMBER(:NEW.game_id),
            TO_NUMBER(:NEW.official_id)
        );
    WHEN OTHERS THEN
        RAISE;
END;
/