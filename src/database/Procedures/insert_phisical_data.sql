CREATE OR REPLACE PROCEDURE insert_physical_data(
    p_combine_id IN NUMBER,
    p_height_wo_shoes IN NUMBER,
    p_height_w_shoes IN NUMBER,
    p_weight IN NUMBER,
    p_wingspan IN NUMBER,
    p_standing_reach IN NUMBER,
    p_body_fat_pct IN NUMBER,
    p_hand_length IN NUMBER,
    p_hand_width IN NUMBER
) IS
BEGIN
    INSERT INTO Physical (
        id_physical,
        Player_Combine_id_combine,
        height_wo_shoes,
        height_w_shoes,
        weight,
        wingspan,
        standing_reach ,
        body_fat_pct,
        hand_length,
        hand_width
    ) VALUES (
        seq_physical_id.NEXTVAL,
        p_combine_id,
        p_height_wo_shoes,
        p_height_w_shoes,
        p_weight,
        p_wingspan,
        p_standing_reach,
        p_body_fat_pct,
        p_hand_length,
        p_hand_width
    );
END;
/
