CREATE OR REPLACE TRIGGER trg_team_details_temp_insert
AFTER INSERT ON team_details_temp
FOR EACH ROW
DECLARE
    v_stadium_id INTEGER;
BEGIN
    -- Insertar en la tabla de estadios

    BEGIN
        SELECT id_stadium INTO v_stadium_id FROM Estadium WHERE name = :NEW.arena AND ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO Estadium (id_stadium, name, capacity) 
            VALUES (estadium_seq.NEXTVAL, :NEW.arena, :NEW.arenacapacity) 
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
        estadium_id_stadium = v_stadium_id
    WHERE id_team = :NEW.team_id;

EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END;
/
