-- Trigger para cargar datos de other_stats_temp a Advanced_team_stats
CREATE OR REPLACE TRIGGER trg_other_stats_temp_insert
AFTER INSERT ON other_stats_temp
FOR EACH ROW
DECLARE
    v_home_team_id INTEGER;
    v_away_team_id INTEGER;
BEGIN
    -- Obtener IDs de equipos local y visitante

    v_home_team_id := get_or_create_team(:NEW.team_abbreviation_home, :NEW.team_id_home);
    
    -- Insertar estadísticas avanzadas del equipo local
    INSERT INTO Advanced_team_stats (
        id_stats,
        pts_paint,
        pts_2nd_chance,
        pts_fb,
        largest_lead,
        team_turnovers,
        total_turnovers,
        team_rebounds,
        pts_off_to_home,
        Games_id_game,
        Teams_id_team
    ) VALUES (
        TO_NUMBER(:NEW.game_id || v_home_team_id),
        :NEW.pts_paint_home,
        :NEW.pts_2nd_chance_home,
        :NEW.pts_fb_home,
        :NEW.largest_lead_home,
        :NEW.team_turnovers_home,
        :NEW.total_turnovers_home,
        :NEW.team_rebounds_home,
        :NEW.pts_off_to_home,
        TO_NUMBER(:NEW.game_id),
        v_home_team_id
    );
    
    v_away_team_id := get_or_create_team(:NEW.team_abbreviation_away, :NEW.team_id_away);
    -- Insertar estadísticas avanzadas del equipo visitante
    INSERT INTO Advanced_team_stats (
        id_stats,
        pts_paint,
        pts_2nd_chance,
        pts_fb,
        largest_lead,
        team_turnovers,
        total_turnovers,
        team_rebounds,
        pts_off_to_away,
        Games_id_game,
        Teams_id_team
    ) VALUES (
        TO_NUMBER(:NEW.game_id || v_away_team_id),
        :NEW.pts_paint_away,
        :NEW.pts_2nd_chance_away,
        :NEW.pts_fb_away,
        :NEW.largest_lead_away,
        :NEW.team_turnovers_away,
        :NEW.total_turnovers_away,
        :NEW.team_rebounds_away,
        :NEW.pts_off_to_away,
        TO_NUMBER(:NEW.game_id),
        v_away_team_id
    );
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        NULL; -- Ignorar duplicados
    WHEN OTHERS THEN
        RAISE;
END;
/