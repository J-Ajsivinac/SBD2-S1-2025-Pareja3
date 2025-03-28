-- Trigger para cargar datos de game_summary_temp a Games (actualizar información adicional)
CREATE OR REPLACE TRIGGER trg_game_summary_temp_insert
AFTER INSERT ON game_summary_temp
FOR EACH ROW
BEGIN
    UPDATE Games
    SET game_sequence = :NEW.game_sequence,
        game_status_id = :NEW.game_status_id,
        game_status_text = :NEW.game_status_text,
        gamecode = :NEW.gamecode,
        live_period = :NEW.live_period,
        natl_tv_broad_a = :NEW.natl_tv_broadcaster_abbreviation,
        wh_status = :NEW.wh_status
    WHERE id_game = TO_NUMBER(:NEW.game_id);
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END;
/