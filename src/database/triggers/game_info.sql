-- No probado aún

CREATE OR REPLACE TRIGGER trg_game_info_temp_insert
AFTER INSERT ON game_info_temp
FOR EACH ROW
BEGIN
    UPDATE Games
    SET game_date = :NEW.game_date,
        attendance = :NEW.attendance,
        game_time = TO_NUMBER(REGEXP_REPLACE(:NEW.game_time, '[^0-9]', ''))
    WHERE id_game = TO_NUMBER(:NEW.game_id);
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END;
/
