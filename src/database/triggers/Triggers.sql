CREATE OR REPLACE TRIGGER trg_team_details_temp_insert
AFTER INSERT ON team_details_temp
FOR EACH ROW
DECLARE
    v_stadium_id INTEGER;
BEGIN
    -- Insertar en la tabla de estadios
    BEGIN
        INSERT INTO estadium (
            id_stadium, name, capacity
        ) VALUES (
            estadium_seq.NEXTVAL, :NEW.arena, :NEW.capacity
        )
        RETURNING id_stadium INTO v_stadium_id;
    END;

    -- Actualizar el equipo con los nuevos detalles
    UPDATE Teams
    SET owner = :NEW.owner,
        generalManager = :NEW.generalmanager,
        headcoach = :NEW.headcoach,
        dleagueaffiliation = :NEW.dleagueaffiliation,
        facebook = :NEW.facebook,
        instagram = :NEW.instagram,
        twitter = :NEW.twitter,
        stadium_id_stadium = v_stadium_id
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
