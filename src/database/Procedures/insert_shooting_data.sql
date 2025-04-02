CREATE OR REPLACE PROCEDURE insert_shooting_data(
    p_combine_id IN NUMBER,
    p_shot_type IN VARCHAR2,
    p_position IN VARCHAR2,
    p_percentage IN VARCHAR2
) IS
BEGIN
    IF p_percentage IS NOT NULL THEN
        INSERT INTO Shooting (
            id_shooting,
            Player_Combine_id_combine,
            shot_type,
            position,
            percentaje
        ) VALUES (
            seq_shooting_id.NEXTVAL,
            p_combine_id,
            p_shot_type,
            p_position,
            p_percentage
        );
    END IF;
END;
/