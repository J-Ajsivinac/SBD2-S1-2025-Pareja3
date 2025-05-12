-- Procedimiento para insertar puntuaciones de overtime
CREATE OR REPLACE PROCEDURE insert_overtime_score(
    p_game_id IN NUMBER,
    p_ot_num IN NUMBER,
    p_points IN NUMBER,
    p_team_type IN VARCHAR2
) IS
BEGIN
    IF p_points IS NOT NULL AND p_points > 0 THEN
        INSERT INTO Overtime_score (
            id_overtime,
            ot_num,
            points,
            Games_id_game,
            team_type
        ) VALUES (
            overtime_score_seq.NEXTVAL,
            p_ot_num,
            p_points,
            p_game_id,
            p_team_type
        );
    END IF;
END insert_overtime_score;
/