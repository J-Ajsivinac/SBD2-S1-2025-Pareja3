#!/bin/bash
set -e

# Asegurar que tenemos acceso a la base de datos
echo "Verificando conexión a PostgreSQL..."
PGPASSWORD=replica_pass psql -h postgresql-slave -U replica -d app_db -c "SELECT 1" || { echo "Error: No se puede conectar a PostgreSQL"; exit 1; }

# Exportar contraseña para pgbackrest
export PGPASSWORD=replica_pass

# Crear la estancia pgBackRest con opciones para SSH
echo "Creando estancia de pgBackRest..."
pgbackrest --stanza=postgres --pg1-host=slave --pg1-path=/var/lib/postgresql/data --pg1-port=5432 --pg1-user=replica --repo1-path=/var/lib/pgbackrest  stanza-create

# Verificar la configuración con las mismas opciones
echo "Verificando configuración..."
pgbackrest --stanza=postgres --pg1-host=slave --pg1-path=/var/lib/postgresql/data --pg1-port=5432 --pg1-user=replica --repo1-path=/var/lib/pgbackrest check

echo "Configuración de estancia completada correctamente"

# Configuración de pgBackRest global
cat <<EOF > /etc/pgbackrest.conf
[global]
repo1-path=/var/lib/pgbackrest
repo1-retention-full=2
process-max=4
log-level-console=info
log-level-file=debug
start-fast=y

[postgres]
pg1-path=/var/lib/postgresql/data
pg1-port=5432
pg1-host=postgresql-slave
pg1-user=replica
EOF
