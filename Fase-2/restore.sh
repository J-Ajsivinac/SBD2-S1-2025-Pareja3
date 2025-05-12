#!/bin/bash

CONTAINER_NAME="restore-db"

echo ">>> Iniciando restauración en $CONTAINER_NAME..."

# 1. Limpiar la carpeta de datos
docker exec -it $CONTAINER_NAME bash -c "rm -rf /bitnami/postgresql/data/*"

# 2. Restaurar desde el backup
docker exec -it $CONTAINER_NAME bash -c "pgbackrest --stanza=postgres --config=/etc/pgbackrest/pgbackrest.conf restore"

# 3. Crear carpeta de configuraciones si no existe
docker exec -it --user root $CONTAINER_NAME bash -c "mkdir -p /bitnami/postgresql/conf"

# 4. Copiar los archivos de configuración personalizados
docker exec -it --user root $CONTAINER_NAME bash -c "cp /custom-configs/postgresql.conf /bitnami/postgresql/conf/postgresql.conf"
docker exec -it --user root $CONTAINER_NAME bash -c "cp /custom-configs/repmgr.conf /bitnami/postgresql/conf/repmgr.conf"
docker exec -it --user root $CONTAINER_NAME bash -c "cp /custom-configs/pg_hba.conf /bitnami/postgresql/conf/pg_hba.conf"

# 5. Crear carpeta conf.d si no existe
docker exec -it --user root $CONTAINER_NAME bash -c "mkdir -p /bitnami/postgresql/conf/conf.d"

# 6. Iniciar PostgreSQL manualmente apuntando al nuevo path de configuración
docker exec -it $CONTAINER_NAME bash -c "postgres -D /bitnami/postgresql/conf"

echo ">>> Proceso de restauración completado."


# 7. Ejecuctar el script de configuración
# docker exec -d $CONTAINER_NAME bash -c "postgres -D /bitnami/postgresql/conf"