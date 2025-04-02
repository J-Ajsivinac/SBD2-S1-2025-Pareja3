-- Trigger para insertar datos en Quarter_score y Overtime_score
CREATE OR REPLACE TRIGGER trg_line_score_temp_insert
AFTER INSERT ON line_score_temp
FOR EACH ROW
BEGIN
    -- Procesar cuartos para ambos equipos
    FOR i IN 1..4 LOOP
        -- Equipo local
        insert_quarter_score(
            TO_NUMBER(:NEW.game_id),
            i,
            CASE 
                WHEN i = 1 THEN :NEW.pts_qtr1_home
                WHEN i = 2 THEN :NEW.pts_qtr2_home
                WHEN i = 3 THEN :NEW.pts_qtr3_home
                WHEN i = 4 THEN :NEW.pts_qtr4_home
            END,
            'HOME'
        );
        
        -- Equipo visitante
        insert_quarter_score(
            TO_NUMBER(:NEW.game_id),
            i,
            CASE 
                WHEN i = 1 THEN :NEW.pts_qtr1_away
                WHEN i = 2 THEN :NEW.pts_qtr2_away
                WHEN i = 3 THEN :NEW.pts_qtr3_away
                WHEN i = 4 THEN :NEW.pts_qtr4_away
            END,
            'AWAY'
        );
    END LOOP;
    
    -- Procesar tiempos extras para ambos equipos
    FOR i IN 1..10 LOOP
        -- Equipo local
        insert_overtime_score(
            TO_NUMBER(:NEW.game_id),
            i,
            CASE 
                WHEN i = 1 THEN :NEW.pts_ot1_home
                WHEN i = 2 THEN :NEW.pts_ot2_home
                WHEN i = 3 THEN :NEW.pts_ot3_home
                WHEN i = 4 THEN :NEW.pts_ot4_home
                WHEN i = 5 THEN :NEW.pts_ot5_home
                WHEN i = 6 THEN :NEW.pts_ot6_home
                WHEN i = 7 THEN :NEW.pts_ot7_home
                WHEN i = 8 THEN :NEW.pts_ot8_home
                WHEN i = 9 THEN :NEW.pts_ot9_home
                WHEN i = 10 THEN :NEW.pts_ot10_home
            END,
            'HOME'
        );
        
        -- Equipo visitante
        insert_overtime_score(
            TO_NUMBER(:NEW.game_id),
            i,
            CASE 
                WHEN i = 1 THEN :NEW.pts_ot1_away
                WHEN i = 2 THEN :NEW.pts_ot2_away
                WHEN i = 3 THEN :NEW.pts_ot3_away
                WHEN i = 4 THEN :NEW.pts_ot4_away
                WHEN i = 5 THEN :NEW.pts_ot5_away
                WHEN i = 6 THEN :NEW.pts_ot6_away
                WHEN i = 7 THEN :NEW.pts_ot7_away
                WHEN i = 8 THEN :NEW.pts_ot8_away
                WHEN i = 9 THEN :NEW.pts_ot9_away
                WHEN i = 10 THEN :NEW.pts_ot10_away
            END,
            'AWAY'
        );
    END LOOP;
END;
/

ALTER TABLE Quarter_score ADD team_type VARCHAR2(10);
ALTER TABLE Overtime_score ADD team_type VARCHAR2(10);

ALTER TABLE Play_by_play DROP COLUMN id_play;
ALTER TABLE Play_by_play MODIFY homedescription VARCHAR2(100);
ALTER TABLE Play_by_play MODIFY neutraldescription VARCHAR2(100);
ALTER TABLE Play_by_play MODIFY visitordescription VARCHAR2(100);
ALTER TABLE Advanced_team_stats MODIFY total_turnovers NULL;
ALTER TABLE Advanced_team_stats MODIFY team_turnovers NULL;
ALTER TABLE Advanced_team_stats MODIFY team_rebounds NULL;

ALTER TABLE Player_Combine MODIFY Players_id_player NULL;
ALTER TABLE Shooting MODIFY percentaje VARCHAR2(20);