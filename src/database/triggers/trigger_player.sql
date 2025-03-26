create or replace TRIGGER trg_insert_players
AFTER INSERT ON player_temp
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