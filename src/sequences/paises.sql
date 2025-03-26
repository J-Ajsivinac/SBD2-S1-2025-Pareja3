-- Crear la secuencia
CREATE SEQUENCE paises START WITH 1;

-- Crear el trigger
CREATE OR REPLACE TRIGGER trg_autoincrement_countries
BEFORE INSERT ON countries
FOR EACH ROW
WHEN (NEW.id_country IS NULL)
BEGIN
    SELECT paises.NEXTVAL INTO :NEW.id_country FROM dual;
END;
/