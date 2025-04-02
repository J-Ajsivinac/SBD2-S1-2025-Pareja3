CREATE OR REPLACE FUNCTION get_or_create_team (
    p_abbreviation VARCHAR2,
    p_id_team NUMBER
) RETURN NUMBER IS
    v_team_id NUMBER;
    v_city_id INTEGER;
    v_stadium_id INTEGER;
    v_state_id INTEGER;
    v_country_id INTEGER;
BEGIN
    BEGIN
        -- Buscar el equipo existente
        SELECT id_team INTO v_team_id 
        FROM Teams 
        WHERE id_team = p_id_team OR abbreviation = p_abbreviation
        AND ROWNUM = 1;

        RETURN v_team_id;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- Ciudad
            BEGIN
                SELECT id_city INTO v_city_id FROM Cities WHERE city = 'Unknown' AND ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    INSERT INTO Cities (id_city, city) 
                    VALUES (city_seq.NEXTVAL, 'Unknown') 
                    RETURNING id_city INTO v_city_id;
            END;

            -- Estadio
            BEGIN
                SELECT id_stadium INTO v_stadium_id FROM Estadium WHERE name = 'Unknown' AND ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    INSERT INTO Estadium (id_stadium, name, capacity) 
                    VALUES (estadium_seq.NEXTVAL, 'Unknown', 0) 
                    RETURNING id_stadium INTO v_stadium_id;
            END;

            -- Estado
            BEGIN
                SELECT id_state INTO v_state_id FROM State WHERE state = 'Unknown' AND ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    -- País
                    BEGIN
                        SELECT id_country INTO v_country_id FROM Countries WHERE pais = 'Unknown' AND ROWNUM = 1;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            INSERT INTO Countries (id_country, pais) 
                            VALUES (countries_seq.NEXTVAL, 'Unknown') 
                            RETURNING id_country INTO v_country_id;
                    END;

                    INSERT INTO State (id_state, state, Countries_id_country) 
                    VALUES (state_seq.NEXTVAL, 'Unknown', v_country_id) 
                    RETURNING id_state INTO v_state_id;
            END;

            -- Insertar el equipo
            INSERT INTO Teams (
                id_team, 
                abbreviation, 
                full_name,
                nickname,
                Cities_id_city,
                Estadium_id_stadium,
                State_id_state,
                year_founded
            ) VALUES (
                p_id_team,
                p_abbreviation,
                p_abbreviation || ' Team',
                p_abbreviation,
                v_city_id,
                v_stadium_id,
                v_state_id,
                EXTRACT(YEAR FROM SYSDATE)
            ) RETURNING id_team INTO v_team_id;

            RETURN v_team_id;
    END;
END;
/