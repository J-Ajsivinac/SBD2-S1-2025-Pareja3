-- Tabla de Eventos en Juegos (play_by_play)
CREATE TABLE PlayByPlay (
    game_id NUMBER,
    eventnum NUMBER,
    eventmsgtype NUMBER,
    eventmsgactiontype NUMBER,
    period NUMBER,
    wctimestring VARCHAR2(20),
    pctimestring VARCHAR2(20),
    homedescription VARCHAR2(255),
    neutraldescription VARCHAR2(255),
    visitordescription VARCHAR2(255),
    score NUMBER,
    scoremargin NUMBER,
    person1type NUMBER,
    player1_id NUMBER,
    player1_name VARCHAR2(100),
    player1_team_id NUMBER,
    player1_team_city VARCHAR2(50),
    player1_team_nickname VARCHAR2(50),
    player1_team_abbreviation VARCHAR2(10),
    person2type NUMBER,
    player2_id NUMBER,
    player2_name VARCHAR2(100),
    player2_team_id NUMBER,
    player2_team_city VARCHAR2(50),
    player2_team_nickname VARCHAR2(50),
    player2_team_abbreviation VARCHAR2(10),
    person3type NUMBER,
    player3_id NUMBER,
    player3_name VARCHAR2(100),
    player3_team_id NUMBER,
    player3_team_city VARCHAR2(50),
    player3_team_nickname VARCHAR2(50),
    player3_team_abbreviation VARCHAR2(10),
    video_available_flag NUMBER
);

-- Tabla de Información de Juegos (game_info)
CREATE TABLE GameInfo (
    game_id NUMBER PRIMARY KEY,
    game_date DATE,
    attendance NUMBER,
    game_time VARCHAR2(20)
);

-- Tabla de Detalles de Equipos (team_details)
CREATE TABLE TeamDetails (
    team_id NUMBER PRIMARY KEY,
    abbreviation VARCHAR2(10),
    nickname VARCHAR2(50),
    year_founded NUMBER,
    city VARCHAR2(50),
    arena VARCHAR2(100),
    arena_capacity NUMBER,
    owner VARCHAR2(100),
    general_manager VARCHAR2(100),
    head_coach VARCHAR2(100),
    dleague_affiliation VARCHAR2(100),
    facebook VARCHAR2(100),
    instagram VARCHAR2(100),
    twitter VARCHAR2(100)
);

-- Tabla de Jugadores (player)
CREATE TABLE Player (
    id NUMBER PRIMARY KEY,
    full_name VARCHAR2(100),
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    is_active NUMBER
);

-- Tabla de Equipos (team)
CREATE TABLE Team (
    id NUMBER PRIMARY KEY,
    full_name VARCHAR2(100),
    abbreviation VARCHAR2(10),
    nickname VARCHAR2(50),
    city VARCHAR2(50),
    state VARCHAR2(50),
    year_founded NUMBER
);

-- Tabla de Historia de Equipos (team_history)
CREATE TABLE TeamHistory (
    team_id NUMBER,
    city VARCHAR2(50),
    nickname VARCHAR2(50),
    year_founded NUMBER,
    year_active_till NUMBER,
    PRIMARY KEY (team_id, year_founded)
);

-- Tabla de Estado de Juegos (game_summary)
CREATE TABLE GameSummary (
    game_date_est DATE,
    game_sequence NUMBER,
    game_id NUMBER PRIMARY KEY,
    game_status_id NUMBER,
    game_status_text VARCHAR2(50),
    gamecode VARCHAR2(50),
    home_team_id NUMBER,
    visitor_team_id NUMBER,
    season NUMBER,
    live_period NUMBER,
    live_pc_time VARCHAR2(20),
    natl_tv_broadcaster_abbreviation VARCHAR2(50),
    live_period_time_bcast VARCHAR2(50),
    wh_status NUMBER
);

-- Tabla de Jugadores Inactivos (inactive_players)
CREATE TABLE InactivePlayers (
    game_id NUMBER,
    player_id NUMBER,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    jersey_num NUMBER,
    team_id NUMBER,
    team_city VARCHAR2(50),
    team_name VARCHAR2(50),
    team_abbreviation VARCHAR2(10),
    PRIMARY KEY (game_id, player_id)
);

-- Tabla de Puntuaciones por Cuarto (line_score)
CREATE TABLE LineScore (
    game_date_est DATE,
    game_sequence NUMBER,
    game_id NUMBER PRIMARY KEY,
    team_id_home NUMBER,
    team_abbreviation_home VARCHAR2(10),
    team_city_name_home VARCHAR2(50),
    team_nickname_home VARCHAR2(50),
    team_wins_losses_home VARCHAR2(10),
    pts_qtr1_home NUMBER,
    pts_qtr2_home NUMBER,
    pts_qtr3_home NUMBER,
    pts_qtr4_home NUMBER,
    pts_ot1_home NUMBER,
    pts_ot2_home NUMBER,
    pts_ot3_home NUMBER,
    pts_ot4_home NUMBER,
    pts_ot5_home NUMBER,
    pts_ot6_home NUMBER,
    pts_ot7_home NUMBER,
    pts_ot8_home NUMBER,
    pts_ot9_home NUMBER,
    pts_ot10_home NUMBER,
    pts_home NUMBER,
    team_id_away NUMBER,
    team_abbreviation_away VARCHAR2(10),
    team_city_name_away VARCHAR2(50),
    team_nickname_away VARCHAR2(50),
    team_wins_losses_away VARCHAR2(10),
    pts_qtr1_away NUMBER,
    pts_qtr2_away NUMBER,
    pts_qtr3_away NUMBER,
    pts_qtr4_away NUMBER,
    pts_ot1_away NUMBER,
    pts_ot2_away NUMBER,
    pts_ot3_away NUMBER,
    pts_ot4_away NUMBER,
    pts_ot5_away NUMBER,
    pts_ot6_away NUMBER,
    pts_ot7_away NUMBER,
    pts_ot8_away NUMBER,
    pts_ot9_away NUMBER,
    pts_ot10_away NUMBER,
    pts_away NUMBER
);



-- Tabla de Árbitros (officials)
CREATE TABLE Officials (
    game_id NUMBER,
    official_id NUMBER,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    jersey_num NUMBER,
    PRIMARY KEY (game_id, official_id)
);

-- Tabla de Estadísticas Adicionales (other_stats)
CREATE TABLE OtherStats (
    game_id NUMBER PRIMARY KEY,
    league_id NUMBER,
    team_id_home NUMBER,
    team_abbreviation_home VARCHAR2(10),
    team_city_home VARCHAR2(50),
    pts_paint_home NUMBER,
    pts_2nd_chance_home NUMBER,
    pts_fb_home NUMBER,
    largest_lead_home NUMBER,
    lead_changes NUMBER,
    times_tied NUMBER,
    team_turnovers_home NUMBER,
    total_turnovers_home NUMBER,
    team_rebounds_home NUMBER,
    pts_off_to_home NUMBER,
    team_id_away NUMBER,
    team_abbreviation_away VARCHAR2(10),
    team_city_away VARCHAR2(50),
    pts_paint_away NUMBER,
    pts_2nd_chance_away NUMBER,
    pts_fb_away NUMBER,
    largest_lead_away NUMBER,
    team_turnovers_away NUMBER,
    total_turnovers_away NUMBER,
    team_rebounds_away NUMBER,
    pts_off_to_away NUMBER
);

-- Tabla de Información Común de Jugadores (common_player_info)
CREATE TABLE CommonPlayerInfo (
    person_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    display_first_last VARCHAR2(100),
    display_last_comma_first VARCHAR2(100),
    display_fi_last VARCHAR2(50),
    player_slug VARCHAR2(100),
    birthdate DATE,
    school VARCHAR2(100),
    country VARCHAR2(50),
    last_affiliation VARCHAR2(100),
    height VARCHAR2(10),
    weight NUMBER,
    season_exp NUMBER,
    jersey NUMBER,
    position VARCHAR2(20),
    rosterstatus VARCHAR2(20),
    games_played_current_season_flag VARCHAR2(10),
    team_id NUMBER,
    team_name VARCHAR2(100),
    team_abbreviation VARCHAR2(10),
    team_code VARCHAR2(10),
    team_city VARCHAR2(50),
    playercode VARCHAR2(50),
    from_year NUMBER,
    to_year NUMBER,
    dleague_flag VARCHAR2(10),
    nba_flag VARCHAR2(10),
    games_played_flag VARCHAR2(10),
    draft_year NUMBER,
    draft_round NUMBER,
    draft_number NUMBER,
    greatest_75_flag VARCHAR2(10)
);

-- Tabla de Estadísticas del Combine de Draft (draft_combine_stats)
CREATE TABLE DraftCombineStats (
    season NUMBER,
    player_id NUMBER,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    player_name VARCHAR2(100),
    position VARCHAR2(20),
    height_wo_shoes NUMBER,
    height_w_shoes NUMBER,
    weight NUMBER,
    wingspan NUMBER,
    standing_reach NUMBER,
    body_fat_pct NUMBER,
    hand_length NUMBER,
    hand_width NUMBER,
    standing_vertical_leap NUMBER,
    max_vertical_leap NUMBER,
    lane_agility_time NUMBER,
    modified_lane_agility_time NUMBER,
    three_quarter_sprint NUMBER,
    bench_press NUMBER
);

-- Tabla de Historial de Draft (draft_history)
CREATE TABLE DraftHistory (
    person_id NUMBER,
    player_name VARCHAR2(100),
    season NUMBER,
    round_number NUMBER,
    round_pick NUMBER,
    overall_pick NUMBER,
    draft_type VARCHAR2(50),
    team_id NUMBER,
    team_city VARCHAR2(50),
    team_name VARCHAR2(100),
    team_abbreviation VARCHAR2(10),
    organization VARCHAR2(100),
    organization_type VARCHAR2(50),
    player_profile_flag NUMBER
);

-- Tabla de Juegos (game)
CREATE TABLE Game (
    season_id NUMBER,
    team_id_home NUMBER,
    team_abbreviation_home VARCHAR2(10),
    team_name_home VARCHAR2(100),
    game_id NUMBER PRIMARY KEY,
    game_date DATE,
    matchup_home VARCHAR2(50),
    wl_home VARCHAR2(10),
    min NUMBER,
    fgm_home NUMBER,
    fga_home NUMBER,
    fg_pct_home NUMBER,
    fg3m_home NUMBER,
    fg3a_home NUMBER,
    fg3_pct_home NUMBER,
    ftm_home NUMBER,
    fta_home NUMBER,
    ft_pct_home NUMBER,
    oreb_home NUMBER,
    dreb_home NUMBER,
    reb_home NUMBER,
    ast_home NUMBER,
    stl_home NUMBER,
    blk_home NUMBER,
    tov_home NUMBER,
    pf_home NUMBER,
    pts_home NUMBER,
    plus_minus_home NUMBER,
    team_id_away NUMBER,
    team_abbreviation_away VARCHAR2(10),
    team_name_away VARCHAR2(100),
    matchup_away VARCHAR2(50),
    wl_away VARCHAR2(10),
    pts_away NUMBER,
    plus_minus_away NUMBER,
    season_type VARCHAR2(20)
);
