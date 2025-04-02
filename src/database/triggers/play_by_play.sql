CREATE OR REPLACE TRIGGER trg_play_by_play_temp_insert
AFTER INSERT ON play_by_play_temp
FOR EACH ROW
DECLARE
    v_play_id INTEGER;
BEGIN
    SELECT NVL(MAX(Play_by_play_ID), 0) + 1 INTO v_play_id FROM Play_by_play;
    
    INSERT INTO Play_by_play (
        Play_by_play_ID,
        Games_id_game,
        eventnum,
        eventmsgactiontype,
        eventmsgtype,
        wctimestring,
        pctimestring,
        scoremargin,
        video_available_flag,
        period,
        score,
        homedescription,
        neutraldescription,
        visitordescription
    ) VALUES (
        v_play_id,
        TO_NUMBER(:NEW.game_id),
        :NEW.eventnum,
        :NEW.eventmsgactiontype,
        :NEW.eventmsgtype,
        :NEW.wctimestring,
        :NEW.pctimestring,
        NVL(:NEW.scoremargin, '0'),
        :NEW.video_available_flag,
        :NEW.period,
        :NEW.score,
        :NEW.homedescription,
        :NEW.neutraldescription,
        :NEW.visitordescription
    );

    -- Llamadas al procedimiento para insertar jugadores
    Insert_Play_by_Play_Player(:NEW.player1_id, :NEW.player1_team_abbreviation, :NEW.person1type, v_play_id);
    Insert_Play_by_Play_Player(:NEW.player2_id, :NEW.player2_team_abbreviation, :NEW.person2type, v_play_id);
    Insert_Play_by_Play_Player(:NEW.player3_id, :NEW.player3_team_abbreviation, :NEW.person3type, v_play_id);

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        NULL;
    WHEN OTHERS THEN
        RAISE;
END;
/
