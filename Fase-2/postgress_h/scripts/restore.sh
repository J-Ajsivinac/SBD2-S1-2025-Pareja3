#!/bin/bash
# /scripts/restore.sh
# Restauración desde backup
# Uso: ./restore.sh [BACKUP_ID]

if [ -z "$1" ]; then
  echo "Debe especificar el ID del backup a restaurar"
  echo "Backups disponibles:"
  pgbackrest info
  exit 1
fi

BACKUP_ID=$1

# Detener servicios
docker stop postgresql-master postgresql-slave pgpool

# Restaurar desde backup
docker exec -it pgbackrest pgbackrest --stanza=postgres --delta --set=$BACKUP_ID restore

# Reiniciar servicios
docker start postgresql-master
sleep 15
docker start postgresql-slave
sleep 10
docker start pgpool

echo "Restauración completada. Verificando servicios..."
docker ps | grep postgres