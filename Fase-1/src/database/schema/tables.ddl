-- Generado por Oracle SQL Developer Data Modeler 24.3.1.351.0831
--   en:        2025-03-13 11:30:48 CST
--   sitio:      Oracle Database 11g
--   tipo:      Oracle Database 11g



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE Advanced_team_stats 
    ( 
     id_stats        INTEGER  NOT NULL , 
     pts_paint       INTEGER  NOT NULL , 
     pts_2nd_chance  INTEGER  NOT NULL , 
     pts_fb          INTEGER  NOT NULL , 
     largest_lead    INTEGER  NOT NULL , 
     team_turnovers  INTEGER  NOT NULL , 
     total_turnovers INTEGER  NOT NULL , 
     team_rebounds   INTEGER  NOT NULL , 
     pts_off_to_home INTEGER , 
     pts_off_to_away INTEGER , 
     Games_id_game   INTEGER  NOT NULL , 
     Teams_id_team   INTEGER  NOT NULL 
    ) 
;

CREATE TABLE Cities 
    ( 
     id_city INTEGER  NOT NULL , 
     city    VARCHAR2 (30) 
    ) 
;

ALTER TABLE Cities 
    ADD CONSTRAINT Cities_PK PRIMARY KEY ( id_city ) ;

CREATE TABLE Countries 
    ( 
     id_country INTEGER  NOT NULL , 
     pais       VARCHAR2 (15) 
    ) 
;

ALTER TABLE Countries 
    ADD CONSTRAINT Countries_PK PRIMARY KEY ( id_country ) ;

CREATE TABLE Draft 
    ( 
     id_draft            INTEGER  NOT NULL , 
     season              INTEGER  NOT NULL , 
     round_number        INTEGER  NOT NULL , 
     round_pick          INTEGER  NOT NULL , 
     overall_pick        INTEGER  NOT NULL , 
     draft_type          VARCHAR2 (6)  NOT NULL , 
     organization        VARCHAR2 (18) , 
     organization_type   VARCHAR2 (50) , 
     player_profile_flag BLOB  NOT NULL , 
     Teams_id_team       INTEGER  NOT NULL , 
     Players_id_player   INTEGER  NOT NULL , 
     Season_id_season    INTEGER  NOT NULL 
    ) 
;

ALTER TABLE Draft 
    ADD CONSTRAINT Draft_PK PRIMARY KEY ( id_draft ) ;

CREATE TABLE Estadium 
    ( 
     id_stadium INTEGER  NOT NULL , 
     name       VARCHAR2 (20) , 
     capacity   INTEGER 
    ) 
;

ALTER TABLE Estadium 
    ADD CONSTRAINT Estadium_PK PRIMARY KEY ( id_stadium ) ;

CREATE TABLE Game_officials 
    ( 
     jersey_num            INTEGER  NOT NULL , 
     Games_id_game         INTEGER  NOT NULL , 
     Officials_id_official INTEGER  NOT NULL 
    ) 
;

CREATE TABLE Games 
    ( 
     id_game          INTEGER  NOT NULL , 
     game_date        DATE , 
     attendance       INTEGER , 
     game_time        INTEGER , 
     Teams_id_team    INTEGER  NOT NULL , 
     Teams_id_team1   INTEGER  NOT NULL , 
     Score_team1      INTEGER , 
     score_team2      INTEGER , 
     game_sequence    INTEGER  NOT NULL , 
     game_status_id   INTEGER  NOT NULL , 
     game_status_text VARCHAR2 (4000) , 
     gamecode         VARCHAR2 (20) , 
     live_period      INTEGER  NOT NULL , 
     live_pc_time     INTEGER , 
     natl_tv_broad_a  VARCHAR2 (4000) , 
     live_p_t_bcast   VARCHAR2 (4)  NOT NULL , 
     wh_status        INTEGER  NOT NULL , 
     Season_id_season INTEGER  NOT NULL 
    ) 
;

ALTER TABLE Games 
    ADD CONSTRAINT Games_PK PRIMARY KEY ( id_game ) ;

CREATE TABLE History 
    ( 
     Teams_id_team    INTEGER  NOT NULL , 
     nickname         VARCHAR2 (10) , 
     city             VARCHAR2 (20) , 
     year_founded     INTEGER , 
     year_active_till INTEGER 
    ) 
;

CREATE TABLE Inactive_players 
    ( 
     jersey_num        INTEGER  NOT NULL , 
     Players_id_player INTEGER  NOT NULL , 
     Teams_id_team     INTEGER  NOT NULL 
    ) 
;

CREATE TABLE Officials 
    ( 
     id_official INTEGER  NOT NULL , 
     first_name  VARCHAR2 (25)  NOT NULL , 
     last_name   VARCHAR2 (25)  NOT NULL , 
     jersey_num  INTEGER  NOT NULL 
    ) 
;

ALTER TABLE Officials 
    ADD CONSTRAINT Officials_PK PRIMARY KEY ( id_official ) ;

CREATE TABLE Overtime_score 
    ( 
     id_overtime   INTEGER  NOT NULL , 
     ot_num        INTEGER  NOT NULL , 
     points        INTEGER  NOT NULL , 
     Games_id_game INTEGER  NOT NULL 
    ) 
;

ALTER TABLE Overtime_score 
    ADD CONSTRAINT Overtime_score_PK PRIMARY KEY ( id_overtime ) ;

CREATE TABLE Play_by_play 
    ( 
     jersey_num           INTEGER , 
     Games_id_game        INTEGER  NOT NULL , 
     Teams_id_team        INTEGER  NOT NULL , 
     Players_id_player    INTEGER  NOT NULL , 
     eventnum             INTEGER  NOT NULL , 
     eventmsgactiontype   INTEGER  NOT NULL , 
     eventmsgtype         INTEGER  NOT NULL , 
     wctimestring         VARCHAR2 (4000)  NOT NULL , 
     pctimestring         VARCHAR2 (4000)  NOT NULL , 
     scoremargin          VARCHAR2 (10)  NOT NULL , 
     video_available_flag BLOB  NOT NULL , 
     period               INTEGER  NOT NULL , 
     score                VARCHAR2 (10) , 
     homedescription      VARCHAR2 (40) , 
     neutraldescription   VARCHAR2 (40) , 
     visitordescription   VARCHAR2 (40) 
    ) 
;

CREATE TABLE Players 
    ( 
     id_player            INTEGER  NOT NULL , 
     full_name            VARCHAR2 (100) , 
     first_name           VARCHAR2 (4000) , 
     las_name             VARCHAR2 (4000) , 
     is_active            CHAR (1) , 
     birthdate            TIMESTAMP  NOT NULL , 
     school               VARCHAR2 (4000)  NOT NULL , 
     last_affiliation     VARCHAR2 (4000)  NOT NULL , 
     height               VARCHAR2 (4000)  NOT NULL , 
     weight               VARCHAR2 (4000)  NOT NULL , 
     playercode           VARCHAR2 (4000)  NOT NULL , 
     greatest_75_flag     BLOB  NOT NULL , 
     Countries_id_country INTEGER  NOT NULL , 
     Teams_id_team        INTEGER  NOT NULL 
    ) 
;
CREATE UNIQUE INDEX Players__IDX ON Players 
    ( 
     Countries_id_country ASC 
    ) 
;
CREATE UNIQUE INDEX Players__IDXv1 ON Players 
    ( 
     Teams_id_team ASC 
    ) 
;

ALTER TABLE Players 
    ADD CONSTRAINT Players_PK PRIMARY KEY ( id_player ) ;

CREATE TABLE Quarter_score 
    ( 
     id_quarter    INTEGER  NOT NULL , 
     querter_num   INTEGER  NOT NULL , 
     points        INTEGER  NOT NULL , 
     Games_id_game INTEGER  NOT NULL 
    ) 
;

ALTER TABLE Quarter_score 
    ADD CONSTRAINT Quarter_score_PK PRIMARY KEY ( id_quarter ) ;

CREATE TABLE Season 
    ( 
     id_season   INTEGER  NOT NULL , 
     season_year DATE  NOT NULL , 
     season_type DATE  NOT NULL 
    ) 
;

ALTER TABLE Season 
    ADD CONSTRAINT Season_PK PRIMARY KEY ( id_season ) ;

CREATE TABLE State 
    ( 
     id_state             INTEGER  NOT NULL , 
     state                VARCHAR2 (20) , 
     Countries_id_country INTEGER  NOT NULL 
    ) 
;

ALTER TABLE State 
    ADD CONSTRAINT State_PK PRIMARY KEY ( id_state ) ;

CREATE TABLE Teams 
    ( 
     id_team             INTEGER  NOT NULL , 
     full_name           VARCHAR2 (4000) , 
     abbreviation        VARCHAR2 (3) , 
     nickname            VARCHAR2 (10) , 
     year_founded        INTEGER , 
     Cities_id_city      INTEGER  NOT NULL , 
     Estadium_id_stadium INTEGER  NOT NULL , 
     owner               VARCHAR2 (40) , 
     generalManager      VARCHAR2 (40) , 
     headcoach           VARCHAR2 (40) , 
     dleagueaffiliation  VARCHAR2 (40) , 
     facebook            VARCHAR2 (4000) , 
     instagram           VARCHAR2 (4000) , 
     twitter             VARCHAR2 (4000) , 
     State_id_state      INTEGER  NOT NULL , 
     team_wins_losses    VARCHAR2 (5) 
    ) 
;

ALTER TABLE Teams 
    ADD CONSTRAINT Teams_PK PRIMARY KEY ( id_team ) ;

ALTER TABLE Advanced_team_stats 
    ADD CONSTRAINT Advanced_team_stats_Games_FK FOREIGN KEY 
    ( 
     Games_id_game
    ) 
    REFERENCES Games 
    ( 
     id_game
    ) 
;

ALTER TABLE Advanced_team_stats 
    ADD CONSTRAINT Advanced_team_stats_Teams_FK FOREIGN KEY 
    ( 
     Teams_id_team
    ) 
    REFERENCES Teams 
    ( 
     id_team
    ) 
;

ALTER TABLE Draft 
    ADD CONSTRAINT Draft_Players_FK FOREIGN KEY 
    ( 
     Players_id_player
    ) 
    REFERENCES Players 
    ( 
     id_player
    ) 
;

ALTER TABLE Draft 
    ADD CONSTRAINT Draft_Season_FK FOREIGN KEY 
    ( 
     Season_id_season
    ) 
    REFERENCES Season 
    ( 
     id_season
    ) 
;

ALTER TABLE Draft 
    ADD CONSTRAINT Draft_Teams_FK FOREIGN KEY 
    ( 
     Teams_id_team
    ) 
    REFERENCES Teams 
    ( 
     id_team
    ) 
;

ALTER TABLE Game_officials 
    ADD CONSTRAINT Game_officials_Games_FK FOREIGN KEY 
    ( 
     Games_id_game
    ) 
    REFERENCES Games 
    ( 
     id_game
    ) 
;

ALTER TABLE Game_officials 
    ADD CONSTRAINT Game_officials_Officials_FK FOREIGN KEY 
    ( 
     Officials_id_official
    ) 
    REFERENCES Officials 
    ( 
     id_official
    ) 
;

ALTER TABLE Games 
    ADD CONSTRAINT Games_Season_FK FOREIGN KEY 
    ( 
     Season_id_season
    ) 
    REFERENCES Season 
    ( 
     id_season
    ) 
;

ALTER TABLE Games 
    ADD CONSTRAINT Games_Teams_FK FOREIGN KEY 
    ( 
     Teams_id_team
    ) 
    REFERENCES Teams 
    ( 
     id_team
    ) 
;

ALTER TABLE Games 
    ADD CONSTRAINT Games_Teams_FKv1 FOREIGN KEY 
    ( 
     Teams_id_team1
    ) 
    REFERENCES Teams 
    ( 
     id_team
    ) 
;

ALTER TABLE History 
    ADD CONSTRAINT History_Teams_FK FOREIGN KEY 
    ( 
     Teams_id_team
    ) 
    REFERENCES Teams 
    ( 
     id_team
    ) 
;

ALTER TABLE Inactive_players 
    ADD CONSTRAINT Inactive_players_Players_FK FOREIGN KEY 
    ( 
     Players_id_player
    ) 
    REFERENCES Players 
    ( 
     id_player
    ) 
;

ALTER TABLE Inactive_players 
    ADD CONSTRAINT Inactive_players_Teams_FK FOREIGN KEY 
    ( 
     Teams_id_team
    ) 
    REFERENCES Teams 
    ( 
     id_team
    ) 
;

ALTER TABLE Overtime_score 
    ADD CONSTRAINT Overtime_score_Games_FK FOREIGN KEY 
    ( 
     Games_id_game
    ) 
    REFERENCES Games 
    ( 
     id_game
    ) 
;

ALTER TABLE Play_by_play 
    ADD CONSTRAINT Play_by_play_Games_FK FOREIGN KEY 
    ( 
     Games_id_game
    ) 
    REFERENCES Games 
    ( 
     id_game
    ) 
;

ALTER TABLE Play_by_play 
    ADD CONSTRAINT Play_by_play_Players_FK FOREIGN KEY 
    ( 
     Players_id_player
    ) 
    REFERENCES Players 
    ( 
     id_player
    ) 
;

ALTER TABLE Play_by_play 
    ADD CONSTRAINT Play_by_play_Teams_FK FOREIGN KEY 
    ( 
     Teams_id_team
    ) 
    REFERENCES Teams 
    ( 
     id_team
    ) 
;

ALTER TABLE Players 
    ADD CONSTRAINT Players_Countries_FK FOREIGN KEY 
    ( 
     Countries_id_country
    ) 
    REFERENCES Countries 
    ( 
     id_country
    ) 
;

ALTER TABLE Players 
    ADD CONSTRAINT Players_Teams_FK FOREIGN KEY 
    ( 
     Teams_id_team
    ) 
    REFERENCES Teams 
    ( 
     id_team
    ) 
;

ALTER TABLE Quarter_score 
    ADD CONSTRAINT Quarter_score_Games_FK FOREIGN KEY 
    ( 
     Games_id_game
    ) 
    REFERENCES Games 
    ( 
     id_game
    ) 
;

ALTER TABLE State 
    ADD CONSTRAINT State_Countries_FK FOREIGN KEY 
    ( 
     Countries_id_country
    ) 
    REFERENCES Countries 
    ( 
     id_country
    ) 
;

ALTER TABLE Teams 
    ADD CONSTRAINT Teams_Cities_FK FOREIGN KEY 
    ( 
     Cities_id_city
    ) 
    REFERENCES Cities 
    ( 
     id_city
    ) 
;

ALTER TABLE Teams 
    ADD CONSTRAINT Teams_Estadium_FK FOREIGN KEY 
    ( 
     Estadium_id_stadium
    ) 
    REFERENCES Estadium 
    ( 
     id_stadium
    ) 
;

ALTER TABLE Teams 
    ADD CONSTRAINT Teams_State_FK FOREIGN KEY 
    ( 
     State_id_state
    ) 
    REFERENCES State 
    ( 
     id_state
    ) 
;



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            17
-- CREATE INDEX                             2
-- ALTER TABLE                             36
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
