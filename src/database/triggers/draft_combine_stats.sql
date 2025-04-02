CREATE OR REPLACE TRIGGER trg_normalize_combine_data
AFTER INSERT ON draft_combine_stats_temp
FOR EACH ROW
DECLARE
    v_combine_id NUMBER;
    v_temp_id NUMBER;
BEGIN
    -- v_season_id := get_season_id(:NEW.season);
    v_temp_id := get_or_create_player(:NEW.player_id, :NEW.player_name);
    insert_player_combine(v_temp_id, :NEW.season, v_combine_id,:NEW.position_);
    insert_physical_data(v_combine_id, :NEW.height_wo_shoes, :NEW.height_w_shoes, :NEW.weight, :NEW.wingspan, :NEW.standing_reach, :NEW.body_fat_pct, :NEW.hand_length, :NEW.hand_width);
    insert_athletic_data(v_combine_id, :NEW.standing_vertical_leap, :NEW.max_vertical_leap, :NEW.lane_agility_time, :NEW.modified_lane_agility_time, :NEW.three_quarter_sprint, :NEW.bench_press);
    
    -- -- Inserción de datos de tiro
    insert_shooting_data(v_combine_id, 'spot_fifteen', 'corner_left', :NEW.spot_fifteen_break_left);
    insert_shooting_data(v_combine_id, 'spot_fifteen', 'break_left', :NEW.spot_fifteen_corner_left);
    insert_shooting_data(v_combine_id, 'spot_fifteen', 'top_key', :NEW.spot_fifteen_top_key);
    insert_shooting_data(v_combine_id, 'spot_fifteen', 'break_right', :NEW.spot_fifteen_break_right);
    insert_shooting_data(v_combine_id, 'spot_fifteen', 'corner_right', :NEW.spot_fifteen_corner_right);
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error en trigger para player_id ' || :NEW.player_id || ': ' || SQLERRM);
        RAISE;
END;
/