BEGIN
  -- Paso 1: TRUNCAR TODAS LAS TABLAS
  FOR t IN (SELECT table_name FROM user_tables) LOOP
    BEGIN
      EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || t.table_name || ' CASCADE';
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('No se pudo truncar la tabla: ' || t.table_name || ' - ' || SQLERRM);
    END;
  END LOOP;

  -- Paso 2: REINICIAR TODAS LAS SECUENCIAS
  FOR s IN (SELECT sequence_name FROM user_sequences) LOOP
    BEGIN
      EXECUTE IMMEDIATE 'DROP SEQUENCE ' || s.sequence_name;
      EXECUTE IMMEDIATE 'CREATE SEQUENCE ' || s.sequence_name || ' START WITH 1';
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('No se pudo reiniciar la secuencia: ' || s.sequence_name || ' - ' || SQLERRM);
    END;
  END LOOP;
END;
/