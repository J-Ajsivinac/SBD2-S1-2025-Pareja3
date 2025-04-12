CREATE OR REPLACE TRIGGER trg_draft
AFTER INSERT ON draft_history_temp
FOR EACH ROW

DECLARE
    v_team_id NUMBER;
    v_player_id NUMBER;
BEGIN

v_team_id := get_or_create_team(:NEW.team_abbreviation, :NEW.team_id);
v_player_id := get_or_create_player(:NEW.person_id, :NEW.player_name);

-- insert into draft
insert into draft (
    id_draft,
    season,
    round_number,
    round_pick,
    overall_pick,
    draft_type,
    organization,
    organization_type,
    player_profile_flag,
    teams_id_team,
    players_id_player
) values (
    id_draft.nextval,
    :NEW.season,
    :NEW.round_number,
    :NEW.round_pick,
    :NEW.overall_pick,
    :NEW.draft_type,
    :NEW.organization_,
    :NEW.organization_type,
    :NEW.player_profile_flag,
    v_team_id,
    v_player_id
);
EXCEPTION
    -- retornar el error 
    WHEN DUP_VAL_ON_INDEX THEN
        NULL; -- Ignorar duplicados
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Error en el trigger: ' || SQLERRM || ' ID: ' || :NEW.person_id|| ' DRAFT: ' || :NEW.draft_type);
END;
/
