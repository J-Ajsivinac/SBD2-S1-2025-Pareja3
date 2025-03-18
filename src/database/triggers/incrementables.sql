-- estadium

CREATE SEQUENCE estadium_seq START WITH 1 INCREMENT BY 1;

create or replace TRIGGER trg_autoincrement_estadium
BEFORE INSERT ON estadium
FOR EACH ROW
WHEN (NEW.id_stadium IS NULL)  
BEGIN
    SELECT estadium_seq.NEXTVAL INTO :NEW.id_stadium FROM dual;
END;

-- paises

CREATE SEQUENCE paises START WITH 1

create or replace TRIGGER trg_autoincrement_countries
BEFORE INSERT ON countries
FOR EACH ROW
WHEN (NEW.id_country IS NULL)  -- Solo si no se especifica un ID manualmente
BEGIN
    SELECT paises.NEXTVAL INTO :NEW.id_country FROM dual;
END;