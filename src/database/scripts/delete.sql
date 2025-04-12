DROP SEQUENCE city_seq;
DROP SEQUENCE estadium_seq;
DROP SEQUENCE state_seq;
DROP SEQUENCE countries_seq;
DROP SEQUENCE teams_seq;

DROP SEQUENCE quarter_score_seq;
DROP SEQUENCE overtime_score_seq;
DROP SEQUENCE id_draft;
DROP SEQUENCE paises;

DROP SEQUENCE seq_combine_id ;
DROP SEQUENCE seq_physical_id ;
DROP SEQUENCE seq_athletic_id ;
DROP SEQUENCE seq_shooting_id ;
DROP SEQUENCE seq_pbp_player_id ;

DROP TABLE TEAM_DETAILS_TEMP;
TRUNCATE TABLE line_score_temp;
TRUNCATE TABLE games;
TRUNCATE TABLE game_temp;
TRUNCATE TABLE game_info_temp;
TRUNCATE TABLE game_summary_temp;

TRUNCATE TABLE player_combine CASCADE;
TRUNCATE TABLE Physical;
TRUNCATE TABLE Athletic;
TRUNCATE TABLE draft_combine_stats_temp;

TRUNCATE TABLE Quarter_score;
TRUNCATE TABLE Overtime_score;
TRUNCATE TABLE TEAM_TEMP;

TRUNCATE TABLE pbp_players;
TRUNCATE TABLE Play_by_play;
TRUNCATE TABLE play_by_play_temp;

--  Script para borrar datos de todas las tablas temporales si existen
BEGIN
    FOR t IN (SELECT table_name FROM user_tables WHERE table_name LIKE '%_TEMP')
    LOOP
        EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || t.table_name;
    END LOOP;
END;
/

-- Script para borrar todas las tablas temporales si existen
BEGIN
    FOR t IN (SELECT table_name FROM user_tables WHERE table_name LIKE '%_TEMP')
    LOOP
        EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
    END LOOP;
END;
/

-- Borrar datos de todas las tablas
BEGIN
    FOR t IN (SELECT table_name FROM user_tables)
    LOOP
        EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || t.table_name;
    END LOOP;
END;
/

-- Borrar todas las tablas 
BEGIN
    FOR t IN (SELECT table_name FROM user_tables)
    LOOP
        EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
    END LOOP;
END;
/