CREATE OR REPLACE PROCEDURE insert_athletic_data(
    p_combine_id IN NUMBER,
    p_standing_vertical IN NUMBER,
    p_max_vertical IN NUMBER,
    p_lane_agility IN NUMBER,
    p_modified_agility IN NUMBER,
    p_three_quarter_sprint IN NUMBER,
    p_bench_press IN NUMBER
) IS
BEGIN
    INSERT INTO Athletic (
        id_athletic,
        Player_Combine_id_combine,
        standing_vertical,
        max_vertical,
        lane_agility,
        modified_agility,
        three_quarter_sprint,
        bench_press
    ) VALUES (
        seq_athletic_id.NEXTVAL,
        p_combine_id,
        p_standing_vertical,
        p_max_vertical,
        p_lane_agility,
        p_modified_agility,
        p_three_quarter_sprint,
        p_bench_press
    );
END;
/