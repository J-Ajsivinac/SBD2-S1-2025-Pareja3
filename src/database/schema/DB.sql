
CREATE TABLE Advanced_team_stats 
    ( 
     id_stats        INTEGER  NOT NULL , 
     pts_paint       INTEGER  NOT NULL , 
     pts_2nd_chance  INTEGER  NOT NULL , 
     pts_fb          INTEGER  NOT NULL , 
     largest_lead    INTEGER  NOT NULL , 
     team_turnovers  INTEGER , 
     total_turnovers INTEGER , 
     team_rebounds   INTEGER , 
     pts_off_to_home INTEGER , 
     pts_off_to_away INTEGER , 
     Games_id_game   INTEGER  NOT NULL , 
     Teams_id_team   INTEGER  NOT NULL 
    ) 
;

CREATE TABLE Athletic 
    ( 
     id_athletic               INTEGER  NOT NULL , 
     standing_vertical         NUMBER (6,2) , 
     max_vertical              NUMBER (6,2) , 
     lane_agility              NUMBER (6,2) , 
     modified_agility          NUMBER (6,2) , 
     three_quarter_sprint      NUMBER (6,2) , 
     bench_press               NUMBER (8,2) , 
     Player_Combine_id_combine INTEGER  NOT NULL 
    ) 
;

ALTER TABLE Athletic 
    ADD CONSTRAINT Athletic_PK PRIMARY KEY ( id_athletic ) ;

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
     pais       VARCHAR2 (50) 
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
     draft_type          VARCHAR2 (20)  NOT NULL , 
     organization        VARCHAR2 (100) , 
     organization_type   VARCHAR2 (50) , 
     player_profile_flag BLOB  NOT NULL , 
     Teams_id_team       INTEGER  NOT NULL , 
     Players_id_player   INTEGER  NOT NULL
    ) 
;

ALTER TABLE Draft 
    ADD CONSTRAINT Draft_PK PRIMARY KEY ( id_draft ) ;

CREATE TABLE Estadium 
    ( 
     id_stadium INTEGER  NOT NULL , 
     name       VARCHAR2 (40) , 
     capacity   INTEGER 
    ) 
;

ALTER TABLE Estadium 
    ADD CONSTRAINT Estadium_PK PRIMARY KEY ( id_stadium ) ;

CREATE TABLE Game_officials 
    ( 
     jersey_num            INTEGER , 
     Games_id_game         INTEGER  NOT NULL , 
     Officials_id_official INTEGER  NOT NULL 
    ) 
;

CREATE TABLE Games 
    ( 
     id_game          INTEGER  NOT NULL , 
     game_date        DATE , 
     attendance       INTEGER , 
     game_time        VARCHAR2(6) , 
     Teams_id_team    INTEGER  NOT NULL , 
     Teams_id_team1   INTEGER  NOT NULL , 
     Score_team1      INTEGER , 
     score_team2      INTEGER , 
     game_sequence    INTEGER , 
     game_status_id   INTEGER  NOT NULL , 
     game_status_text VARCHAR2 (4000) , 
     gamecode         VARCHAR2 (20) , 
     live_period      INTEGER  NOT NULL , 
     live_pc_time     INTEGER , 
     natl_tv_broad_a  VARCHAR2 (4000) , 
     live_p_t_bcast   VARCHAR2 (4)  NOT NULL , 
     wh_status        INTEGER  NOT NULL , 
     pts              INTEGER,
     Season_id_season INTEGER  NOT NULL 
    ) 
;

ALTER TABLE Games 
    ADD CONSTRAINT Games_PK PRIMARY KEY ( id_game ) ;

CREATE TABLE History 
    ( 
     Teams_id_team    INTEGER, 
     nickname         VARCHAR2 (30) , 
     city             VARCHAR2 (20) , 
     year_founded     INTEGER , 
     year_active_till INTEGER 
    ) 
;

CREATE TABLE Inactive_players 
    ( 
     jersey_num        INTEGER, 
     Players_id_player INTEGER  NOT NULL , 
     Teams_id_team     INTEGER  NOT NULL 
    ) 
;

CREATE TABLE Officials 
    ( 
     id_official INTEGER  NOT NULL , 
     first_name  VARCHAR2 (25)  NOT NULL , 
     last_name   VARCHAR2 (25)  NOT NULL , 
     jersey_num  INTEGER
    ) 
;

ALTER TABLE Officials 
    ADD CONSTRAINT Officials_PK PRIMARY KEY ( id_official ) ;

CREATE TABLE Overtime_score 
    ( 
     id_overtime   INTEGER  NOT NULL , 
     ot_num        INTEGER  NOT NULL , 
     points        INTEGER  NOT NULL , 
     Games_id_game INTEGER  NOT NULL ,
     team_type     VARCHAR2(10)
    ) 
;

ALTER TABLE Overtime_score 
    ADD CONSTRAINT Overtime_score_PK PRIMARY KEY ( id_overtime ) ;

CREATE TABLE pbp_players 
    ( 
     id_pbp_player                INTEGER , 
     person_type                  INTEGER , 
     Players_id_player            INTEGER  NOT NULL , 
     Play_by_play_Play_by_play_ID NUMBER  NOT NULL ,
     Teams_id_team                INTEGER
    ) 
;

ALTER TABLE pbp_players 
    ADD CONSTRAINT pbp_players_PK PRIMARY KEY ( Players_id_player ) ;

CREATE TABLE Physical 
    ( 
     id_physical               INTEGER  NOT NULL , 
     height_wo_shoes           NUMBER (6,2) , 
     height_w_shoes            NUMBER (6,2) , 
     weight                    NUMBER (6,2) , 
     wingspan                  NUMBER (6,2) , 
     standing_reach            NUMBER (6,2) , 
     body_fat_pct              NUMBER (8,2) , 
     hand_length               NUMBER (6,2) , 
     hand_width                NUMBER (6,2) , 
     Player_Combine_id_combine INTEGER  NOT NULL 
    ) 
;

ALTER TABLE Physical 
    ADD CONSTRAINT Physical_PK PRIMARY KEY ( id_physical ) ;

CREATE TABLE Play_by_play 
    ( 
    Play_by_play_ID      NUMBER  NOT NULL ,
     Games_id_game        INTEGER  NOT NULL , 
     eventnum             INTEGER  NOT NULL , 
     eventmsgactiontype   INTEGER  NOT NULL , 
     eventmsgtype         INTEGER  NOT NULL , 
     wctimestring         VARCHAR2 (4000), 
     pctimestring         VARCHAR2 (4000), 
     scoremargin          VARCHAR2 (10), 
     video_available_flag BLOB  NOT NULL , 
     period               INTEGER  NOT NULL , 
     score                VARCHAR2 (10) , 
     homedescription      VARCHAR2 (100) , 
     neutraldescription   VARCHAR2 (100) , 
     visitordescription   VARCHAR2 (100)  
    ) 
;

ALTER TABLE Play_by_play 
    ADD CONSTRAINT Play_by_play_PK PRIMARY KEY ( Play_by_play_ID ) ;

CREATE TABLE Player_Combine 
    ( 
     id_combine        INTEGER  NOT NULL , 
     position          VARCHAR2 (50) , 
     season            INTEGER  NOT NULL , 
     Players_id_player INTEGER 
    ) 
;

ALTER TABLE Player_Combine 
    ADD CONSTRAINT Player_Combine_PK PRIMARY KEY ( id_combine ) ;

CREATE TABLE Players 
    ( 
     id_player            INTEGER  NOT NULL , 
     full_name            VARCHAR2 (100) , 
     first_name           VARCHAR2 (4000) , 
     last_name             VARCHAR2 (4000) , 
     is_active            CHAR (1) , 
    birthdate            TIMESTAMP, 
    school               VARCHAR2(4000), 
    last_affiliation     VARCHAR2(4000), 
    height               VARCHAR2(4000), 
    weight               VARCHAR2(4000), 
    playercode           VARCHAR2(4000), 
    greatest_75_flag     VARCHAR2(5), 
    Countries_id_country INTEGER, 
    Teams_id_team        INTEGER
)
;

ALTER TABLE Players 
    ADD CONSTRAINT Players_PK PRIMARY KEY ( id_player ) ;

CREATE TABLE Quarter_score 
    ( 
     id_quarter    INTEGER  NOT NULL , 
     querter_num   INTEGER  NOT NULL , 
     points        INTEGER  NOT NULL , 
     Games_id_game INTEGER  NOT NULL ,
     team_type VARCHAR2(10)
    ) 
;

ALTER TABLE Quarter_score 
    ADD CONSTRAINT Quarter_score_PK PRIMARY KEY ( id_quarter ) ;

CREATE TABLE Season 
    ( 
    id_season   INTEGER  NOT NULL , 
    season_date_o DATE  NOT NULL , 
    season_date_f DATE NOT NULL,
    season_type VARCHAR2(50)  NOT NULL 
    ) 
;

ALTER TABLE Season 
    ADD CONSTRAINT Season_PK PRIMARY KEY ( id_season ) ;

CREATE TABLE Shooting 
    ( 
     id_shooting               INTEGER  NOT NULL , 
     shot_type                 VARCHAR2 (30) , 
     position                  VARCHAR2 (30) , 
     percentaje                VARCHAR2(20) , 
     Player_Combine_id_combine INTEGER  NOT NULL 
    ) 
;

ALTER TABLE Shooting 
    ADD CONSTRAINT Shooting_PK PRIMARY KEY ( id_shooting ) ;

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
     nickname            VARCHAR2 (30) , 
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

ALTER TABLE Athletic 
    ADD CONSTRAINT Athletic_Player_Combine_FK FOREIGN KEY 
    ( 
     Player_Combine_id_combine
    ) 
    REFERENCES Player_Combine 
    ( 
     id_combine
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

ALTER TABLE pbp_players 
    ADD CONSTRAINT pbp_players_Play_by_play_FK FOREIGN KEY 
    ( 
     Play_by_play_Play_by_play_ID
    ) 
    REFERENCES Play_by_play 
    ( 
     Play_by_play_ID
    ) 
;

ALTER TABLE pbp_players 
    ADD CONSTRAINT pbp_players_Players_FK FOREIGN KEY 
    ( 
     Players_id_player
    ) 
    REFERENCES Players 
    ( 
     id_player
    ) 
;

ALTER TABLE Physical 
    ADD CONSTRAINT Physical_Player_Combine_FK FOREIGN KEY 
    ( 
     Player_Combine_id_combine
    ) 
    REFERENCES Player_Combine 
    ( 
     id_combine
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
    ADD CONSTRAINT Play_by_play_Teams_FK FOREIGN KEY 
    ( 
     Teams_id_team
    ) 
    REFERENCES Teams 
    ( 
     id_team
    ) 
;

ALTER TABLE Player_Combine 
    ADD CONSTRAINT Player_Combine_Players_FK FOREIGN KEY 
    ( 
     Players_id_player
    ) 
    REFERENCES Players 
    ( 
     id_player
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

ALTER TABLE Shooting 
    ADD CONSTRAINT Shooting_Player_Combine_FK FOREIGN KEY 
    ( 
     Player_Combine_id_combine
    ) 
    REFERENCES Player_Combine 
    ( 
     id_combine
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
