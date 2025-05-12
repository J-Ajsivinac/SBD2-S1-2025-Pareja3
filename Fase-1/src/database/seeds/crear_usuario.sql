-- 1. Creación del Usuario
CREATE USER BD2_Fase1 IDENTIFIED BY "1234"
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp
QUOTA UNLIMITED ON users;

-- 2. Concesión de Privilegios
-- Privilegios sobre objetos específicos
GRANT INSERT ON common_player_info_temp TO BD2_Fase1;

-- Privilegios de sistema
GRANT CONNECT, RESOURCE TO BD2_Fase1;
GRANT CREATE SESSION, CREATE TABLE TO BD2_Fase1;
GRANT UNLIMITED TABLESPACE TO BD2_Fase1;

-- 3. Verificación del Contenedor Actual
-- Mostrar el nombre del contenedor actual
SHOW CON_NAME;

-- Mostrar los PDBs (Pluggable Databases) disponibles
SHOW PDBS;

-- Cambiar al contenedor XEPDB1 (si es necesario)
ALTER SESSION SET CONTAINER = XEPDB1;

-- 4. Consultas de Información del Usuario
-- Mostrar información de todos los usuarios
SELECT username, account_status, created
FROM dba_users;

-- Mostrar información específica del usuario BD2_FASE1
SELECT * 
FROM dba_users 
WHERE username = 'BD2_FASE1';

-- Mostrar detalles de seguridad del usuario BD2_FASE1
SELECT username, account_status, lock_date, expiry_date, password
FROM dba_users
WHERE username = 'BD2_FASE1';


