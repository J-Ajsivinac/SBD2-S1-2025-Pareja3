#!/bin/bash
mkdir -p $ORACLE_BASE/oradata/dbconfig/$ORACLE_SID
echo "*.db_name='ORCLCDB'" > $ORACLE_BASE/oradata/dbconfig/$ORACLE_SID/initparams.ora
echo "*.db_unique_name='STBY'" >> $ORACLE_BASE/oradata/dbconfig/$ORACLE_SID/initparams.ora
echo "*.log_archive_config='DG_CONFIG=(ORCLCDB,STBY)'" >> $ORACLE_BASE/oradata/dbconfig/$ORACLE_SID/initparams.ora
echo "*.log_archive_dest_1='LOCATION=USE_DB_RECOVERY_FILE_DEST VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=STBY'" >> $ORACLE_BASE/oradata/dbconfig/$ORACLE_SID/initparams.ora
echo "*.log_archive_dest_2='SERVICE=ORCLCDB ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=ORCLCDB'" >> $ORACLE_BASE/oradata/dbconfig/$ORACLE_SID/initparams.ora
echo "*.fal_server='ORCLCDB'" >> $ORACLE_BASE/oradata/dbconfig/$ORACLE_SID/initparams.ora
echo "*.standby_file_management=AUTO" >> $ORACLE_BASE/oradata/dbconfig/$ORACLE_SID/initparams.ora
echo "*.db_file_name_convert='ORCLCDB','STBY'" >> $ORACLE_BASE/oradata/dbconfig/$ORACLE_SID/initparams.ora
echo "*.log_file_name_convert='ORCLCDB','STBY'" >> $ORACLE_BASE/oradata/dbconfig/$ORACLE_SID/initparams.ora

# Iniciar el script por defecto del contenedor
/opt/oracle/runOracle.sh

# Esperar a que la base de datos esté lista
sleep 60

# Configurar el listener para Data Guard
sqlplus / as sysdba <<EOF
-- Crear un archivo de contraseñas
ALTER USER SYS IDENTIFIED BY Hola1234!;
ALTER SYSTEM SET remote_login_passwordfile=EXCLUSIVE SCOPE=SPFILE;

-- Agregar standby redo logs
ALTER DATABASE ADD STANDBY LOGFILE GROUP 4 '/opt/oracle/oradata/STBY/standby_redo01.log' SIZE 200M;
ALTER DATABASE ADD STANDBY LOGFILE GROUP 5 '/opt/oracle/oradata/STBY/standby_redo02.log' SIZE 200M;
ALTER DATABASE ADD STANDBY LOGFILE GROUP 6 '/opt/oracle/oradata/STBY/standby_redo03.log' SIZE 200M;
ALTER DATABASE ADD STANDBY LOGFILE GROUP 7 '/opt/oracle/oradata/STBY/standby_redo04.log' SIZE 200M;

EXIT;
EOF

# Agregar entradas TNS
echo "ORCLCDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = oracle_master)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = ORCLCDB)
    )
  )
" >> $ORACLE_HOME/network/admin/tnsnames.ora

echo "STBY =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = oracle_standby)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = STBY)
    )
  )
" >> $ORACLE_HOME/network/admin/tnsnames.ora

# Mantener el contenedor ejecutándose
tail -f /dev/null