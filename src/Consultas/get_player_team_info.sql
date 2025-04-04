CREATE OR REPLACE PROCEDURE obtener_informacion(
    nombre_parametro IN VARCHAR2,
    tipo IN VARCHAR2
)
IS
    -- Variables para almacenar resultados
    v_full_name VARCHAR2(255);
    v_birthdate DATE;
    v_school VARCHAR2(255);
    v_height VARCHAR2(255);
    v_weight VARCHAR2(255);
    
    v_abbreviation VARCHAR2(10);
    v_year_founded NUMBER;
    v_owner VARCHAR2(255);
    v_team_wins_losses VARCHAR2(255);
    v_state VARCHAR2(50);
    v_pais VARCHAR2(50);
    v_stadium_name VARCHAR2(255);
    v_city VARCHAR2(50);
    
BEGIN
    IF tipo = 'jugador' THEN
        -- Verifica si el jugador existe
        SELECT players.full_name, players.birthdate, players.school, players.height, players.weight
        INTO v_full_name, v_birthdate, v_school, v_height, v_weight
        FROM players
        INNER JOIN countries ON players.Countries_id_country = countries.id_country
        WHERE players.full_name = nombre_parametro;

        IF v_full_name IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('Jugador: ' || v_full_name || ', Fecha de Nacimiento: ' || v_birthdate || 
                                 ', Escuela: ' || v_school || ', Altura: ' || v_height || ', Peso: ' || v_weight);
        ELSE
            DBMS_OUTPUT.PUT_LINE('No se encontró un jugador con ese nombre');
        END IF;

    ELSIF tipo = 'equipo' THEN
        -- Verifica si el equipo existe
        SELECT teams.full_name, teams.abbreviation, teams.year_founded, teams.owner, teams.team_wins_losses, 
               state.state, countries.pais, estadium.name, cities.city
        INTO v_full_name, v_abbreviation, v_year_founded, v_owner, v_team_wins_losses, 
             v_state, v_pais, v_stadium_name, v_city
        FROM teams
        INNER JOIN state ON state.id_state = teams.State_id_state
        INNER JOIN countries ON countries.id_country = state.Countries_id_country
        INNER JOIN estadium ON estadium.id_stadium = teams.Estadium_id_stadium
        INNER JOIN cities ON cities.id_city = teams.Cities_id_city
        WHERE teams.full_name = nombre_parametro;

        IF v_full_name IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('Equipo: ' || v_full_name || ', Abreviatura: ' || v_abbreviation || 
                                 ', Año de Fundación: ' || v_year_founded || ', Propietario: ' || v_owner || 
                                 ', Récord: ' || v_team_wins_losses || ', Estado: ' || v_state || 
                                 ', País: ' || v_pais || ', Estadio: ' || v_stadium_name || 
                                 ', Ciudad: ' || v_city);
        ELSE
            DBMS_OUTPUT.PUT_LINE('No se encontró un equipo con ese nombre');
        END IF;

    ELSE
        DBMS_OUTPUT.PUT_LINE('Tipo inválido. Debe ser "jugador" o "equipo".');
    END IF;
END obtener_informacion;



SET SERVEROUTPUT ON;
EXEC obtener_informacion('Utah Jazz', 'equipo');
