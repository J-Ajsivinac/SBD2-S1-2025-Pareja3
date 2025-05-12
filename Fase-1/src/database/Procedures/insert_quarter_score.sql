-- Procedimiento para insertar puntuaciones en quarter
CREATE OR REPLACE PROCEDURE insert_quarter_score(
    p_game_id IN NUMBER,
    p_quarter_num IN NUMBER,
    p_points IN NUMBER,
    p_team_type IN VARCHAR2
) IS
BEGIN
    IF p_points IS NOT NULL THEN
        INSERT INTO Quarter_score (
            id_quarter,
            querter_num,
            points,
            Games_id_game,
            team_type
        ) VALUES (
            quarter_score_seq.NEXTVAL,
            p_quarter_num,
            p_points,
            p_game_id,
            p_team_type
        );
    END IF;
END insert_quarter_score;
/