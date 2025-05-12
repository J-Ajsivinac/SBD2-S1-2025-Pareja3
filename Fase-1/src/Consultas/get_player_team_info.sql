CREATE OR REPLACE PROCEDURE obtener_informacion(
    nombre_parametro IN VARCHAR2,
    tipo IN VARCHAR2
)
IS
    -- Variables para jugador
    v_id_player NUMBER;
    v_full_name VARCHAR2(255);
    v_first_name VARCHAR2(255);
    v_last_name VARCHAR2(255);
    v_is_active VARCHAR2(10);
    v_birthdate DATE;
    v_school VARCHAR2(255);
    v_last_affiliation VARCHAR2(255);
    v_height VARCHAR2(255);
    v_weight VARCHAR2(255);
    v_playercode VARCHAR2(255);
    v_greatest_75_flag VARCHAR2(10);
    v_countries_id_country NUMBER;
    v_teams_id_team NUMBER;
    v_player_slug VARCHAR2(255);
    v_season_exp NUMBER;
    v_jersey VARCHAR2(10);
    v_position VARCHAR2(50);
    v_rosterstatus VARCHAR2(50);
    v_games_played_current_season_flag VARCHAR2(10);
    v_from_year NUMBER;
    v_to_year NUMBER;
    v_dleague_flag VARCHAR2(10);
    v_nba_flag VARCHAR2(10);
    v_games_played_flag VARCHAR2(10);
    v_draft_year NUMBER;
    v_draft_round NUMBER;
    v_draft_number NUMBER;
    
    -- Variables para equipo
    v_id_team NUMBER;
    v_team_full_name VARCHAR2(255);
    v_abbreviation VARCHAR2(10);
    v_nickname VARCHAR2(255);
    v_year_founded NUMBER;
    v_cities_id_city NUMBER;
    v_estadium_id_stadium NUMBER;
    v_owner VARCHAR2(255);
    v_generalmanager VARCHAR2(255);
    v_headcoach VARCHAR2(255);
    v_dleagueaffiliation VARCHAR2(255);
    v_facebook VARCHAR2(255);
    v_instagram VARCHAR2(255);
    v_twitter VARCHAR2(255);
    v_state_id_state NUMBER;
    v_team_wins_losses VARCHAR2(255);
    
    -- Variables adicionales para joins
    v_state VARCHAR2(50);
    v_pais VARCHAR2(50);
    v_stadium_name VARCHAR2(255);
    v_city VARCHAR2(50);
    
BEGIN
    IF tipo = 'jugador' THEN
        -- Verifica si el jugador existe
        SELECT 
            p.id_player, p.full_name, p.first_name, p.last_name, 
            p.is_active, p.birthdate, p.school, p.last_affiliation,
            p.height, p.weight, p.playercode, p.greatest_75_flag,
            p.countries_id_country, p.teams_id_team, p.player_slug,
            p.season_exp, p.jersey, p.position, p.rosterstatus,
            p.games_played_current_season_flag, p.from_year, p.to_year,
            p.dleague_flag, p.nba_flag, p.games_played_flag,
            p.draft_year, p.draft_round, p.draft_number
        INTO 
            v_id_player, v_full_name, v_first_name, v_last_name,
            v_is_active, v_birthdate, v_school, v_last_affiliation,
            v_height, v_weight, v_playercode, v_greatest_75_flag,
            v_countries_id_country, v_teams_id_team, v_player_slug,
            v_season_exp, v_jersey, v_position, v_rosterstatus,
            v_games_played_current_season_flag, v_from_year, v_to_year,
            v_dleague_flag, v_nba_flag, v_games_played_flag,
            v_draft_year, v_draft_round, v_draft_number
        FROM players p
        WHERE p.full_name = nombre_parametro;

        IF v_full_name IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('=== INFORMACIÓN DEL JUGADOR ===');
            DBMS_OUTPUT.PUT_LINE(RPAD('ID:', 30) || v_id_player);
            DBMS_OUTPUT.PUT_LINE(RPAD('Nombre completo:', 30) || v_full_name);
            DBMS_OUTPUT.PUT_LINE(RPAD('Primer nombre:', 30) || v_first_name);
            DBMS_OUTPUT.PUT_LINE(RPAD('Apellido:', 30) || v_last_name);
            DBMS_OUTPUT.PUT_LINE(RPAD('Activo:', 30) || v_is_active);
            DBMS_OUTPUT.PUT_LINE(RPAD('Nacimiento:', 30) || TO_CHAR(v_birthdate, 'DD-MM-YYYY'));
            DBMS_OUTPUT.PUT_LINE(RPAD('Escuela:', 30) || v_school);
            DBMS_OUTPUT.PUT_LINE(RPAD('Última afiliación:', 30) || v_last_affiliation);
            DBMS_OUTPUT.PUT_LINE(RPAD('Altura:', 30) || v_height);
            DBMS_OUTPUT.PUT_LINE(RPAD('Peso:', 30) || v_weight);
            DBMS_OUTPUT.PUT_LINE(RPAD('Código de jugador:', 30) || v_playercode);
            DBMS_OUTPUT.PUT_LINE(RPAD('Entre los 75 mejores:', 30) || v_greatest_75_flag);
            DBMS_OUTPUT.PUT_LINE(RPAD('ID País:', 30) || v_countries_id_country);
            DBMS_OUTPUT.PUT_LINE(RPAD('ID Equipo:', 30) || v_teams_id_team);
            DBMS_OUTPUT.PUT_LINE(RPAD('Slug:', 30) || v_player_slug);
            DBMS_OUTPUT.PUT_LINE(RPAD('Experiencia:', 30) || v_season_exp);
            DBMS_OUTPUT.PUT_LINE(RPAD('Dorsal:', 30) || v_jersey);
            DBMS_OUTPUT.PUT_LINE(RPAD('Posición:', 30) || v_position);
            DBMS_OUTPUT.PUT_LINE(RPAD('Estado en plantilla:', 30) || v_rosterstatus);
            DBMS_OUTPUT.PUT_LINE(RPAD('Jugó esta temporada:', 30) || v_games_played_current_season_flag);
            DBMS_OUTPUT.PUT_LINE(RPAD('Desde año:', 30) || v_from_year);
            DBMS_OUTPUT.PUT_LINE(RPAD('Hasta año:', 30) || v_to_year);
            DBMS_OUTPUT.PUT_LINE(RPAD('Bandera D-League:', 30) || v_dleague_flag);
            DBMS_OUTPUT.PUT_LINE(RPAD('Bandera NBA:', 30) || v_nba_flag);
            DBMS_OUTPUT.PUT_LINE(RPAD('Bandera partidos jugados:', 30) || v_games_played_flag);
            DBMS_OUTPUT.PUT_LINE(RPAD('Año draft:', 30) || v_draft_year);
            DBMS_OUTPUT.PUT_LINE(RPAD('Ronda draft:', 30) || v_draft_round);
            DBMS_OUTPUT.PUT_LINE(RPAD('Número draft:', 30) || v_draft_number);
        ELSE
            DBMS_OUTPUT.PUT_LINE('No se encontró un jugador con ese nombre');
        END IF;

    ELSIF tipo = 'equipo' THEN
        -- Verifica si el equipo existe
        SELECT 
            t.id_team, t.full_name, t.abbreviation, t.nickname, 
            t.year_founded, t.cities_id_city, t.estadium_id_stadium,
            t.owner, t.generalmanager, t.headcoach, t.dleagueaffiliation,
            t.facebook, t.instagram, t.twitter, t.state_id_state,
            t.team_wins_losses,
            s.state, c.pais, e.name, ci.city
        INTO 
            v_id_team, v_team_full_name, v_abbreviation, v_nickname,
            v_year_founded, v_cities_id_city, v_estadium_id_stadium,
            v_owner, v_generalmanager, v_headcoach, v_dleagueaffiliation,
            v_facebook, v_instagram, v_twitter, v_state_id_state,
            v_team_wins_losses,
            v_state, v_pais, v_stadium_name, v_city
        FROM teams t
        INNER JOIN state s ON s.id_state = t.State_id_state
        INNER JOIN countries c ON c.id_country = s.Countries_id_country
        INNER JOIN estadium e ON e.id_stadium = t.Estadium_id_stadium
        INNER JOIN cities ci ON ci.id_city = t.Cities_id_city
        WHERE t.full_name = nombre_parametro;

        IF v_team_full_name IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('=== INFORMACIÓN DEL EQUIPO ===');
            DBMS_OUTPUT.PUT_LINE(RPAD('ID:', 30) || v_id_team);
            DBMS_OUTPUT.PUT_LINE(RPAD('Nombre completo:', 30) || v_team_full_name);
            DBMS_OUTPUT.PUT_LINE(RPAD('Abreviatura:', 30) || v_abbreviation);
            DBMS_OUTPUT.PUT_LINE(RPAD('Apodo:', 30) || v_nickname);
            DBMS_OUTPUT.PUT_LINE(RPAD('Año Fundación:', 30) || v_year_founded);
            DBMS_OUTPUT.PUT_LINE(RPAD('Propietario:', 30) || v_owner);
            DBMS_OUTPUT.PUT_LINE(RPAD('Gerente General:', 30) || v_generalmanager);
            DBMS_OUTPUT.PUT_LINE(RPAD('Entrenador:', 30) || v_headcoach);
            DBMS_OUTPUT.PUT_LINE(RPAD('Afiliación D-League:', 30) || v_dleagueaffiliation);
            DBMS_OUTPUT.PUT_LINE(RPAD('Facebook:', 30) || v_facebook);
            DBMS_OUTPUT.PUT_LINE(RPAD('Instagram:', 30) || v_instagram);
            DBMS_OUTPUT.PUT_LINE(RPAD('Twitter:', 30) || v_twitter);
            DBMS_OUTPUT.PUT_LINE(RPAD('Récord (V-D):', 30) || v_team_wins_losses);
            DBMS_OUTPUT.PUT_LINE('--- Información adicional ---');
            DBMS_OUTPUT.PUT_LINE(RPAD('Estado:', 30) || v_state);
            DBMS_OUTPUT.PUT_LINE(RPAD('País:', 30) || v_pais);
            DBMS_OUTPUT.PUT_LINE(RPAD('Estadio:', 30) || v_stadium_name);
            DBMS_OUTPUT.PUT_LINE(RPAD('Ciudad:', 30) || v_city);
        ELSE
            DBMS_OUTPUT.PUT_LINE('No se encontró un equipo con ese nombre');
        END IF;

    ELSE
        DBMS_OUTPUT.PUT_LINE('Tipo inválido. Debe ser "jugador" o "equipo".');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron datos para: ' || nombre_parametro);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END obtener_informacion;
/

SET SERVEROUTPUT ON;
EXEC obtener_informacion('Utah Jazz', 'equipo');
