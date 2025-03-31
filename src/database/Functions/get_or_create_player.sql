CREATE OR REPLACE FUNCTION get_or_create_player(
    person_id in NUMBER,
    p_full_name IN VARCHAR2
) RETURN NUMBER IS
    v_player_id NUMBER;
BEGIN
    -- Verificar si el jugador ya existe
    SELECT id_player INTO v_player_id
    FROM Players
    WHERE id_player = person_id;

    RETURN v_player_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Si no existe, insertar el nuevo jugador
        INSERT INTO Players (id_player, full_name, is_active)
        VALUES (person_id, p_full_name, 3)
        RETURNING person_id INTO v_player_id;

        RETURN v_player_id;
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error en la función get_or_create_player: ' || SQLERRM);
END get_or_create_player;
/