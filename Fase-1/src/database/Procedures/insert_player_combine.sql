CREATE OR REPLACE PROCEDURE insert_player_combine(
    p_player_id IN NUMBER,
    p_season_id IN NUMBER,
    p_combine_id OUT NUMBER,
    p_position IN VARCHAR2
) IS
BEGIN

    INSERT INTO Player_combine (
        id_combine,
        Players_id_player,
        season,
        position
    ) VALUES (
        seq_combine_id.NEXTVAL,
        p_player_id,
        p_season_id,
        p_position 
    )
    RETURNING id_combine INTO p_combine_id;
END;
/