DROP SEQUENCE city_seq;
DROP SEQUENCE estadium_seq;
DROP SEQUENCE state_seq;
DROP SEQUENCE countries_seq;
DROP SEQUENCE teams_seq;


DROP TABLE TEAM_DETAILS_TEMP;
TRUNCATE TABLE TEAM_TEMP;

--  Script para borrar datos de todas las tablas temporales si existen
BEGIN
    FOR t IN (SELECT table_name FROM user_tables WHERE table_name LIKE '%_TEMP')
    LOOP
        EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || t.table_name;
    END LOOP;
END;
/

-- Script para borrar todas las tablas temporales si existen
BEGIN
    FOR t IN (SELECT table_name FROM user_tables WHERE table_name LIKE '%_TEMP')
    LOOP
        EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
    END LOOP;
END;
/

-- Borrar datos de todas las tablas
BEGIN
    FOR t IN (SELECT table_name FROM user_tables)
    LOOP
        EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || t.table_name;
    END LOOP;
END;
/

-- Borrar todas las tablas 
BEGIN
    FOR t IN (SELECT table_name FROM user_tables)
    LOOP
        EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
    END LOOP;
END;
/