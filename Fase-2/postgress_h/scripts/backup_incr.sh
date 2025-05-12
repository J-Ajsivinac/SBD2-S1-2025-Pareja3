#!/bin/bash
# /scripts/backup_incr.sh
# Script para realizar backup incremental

pgbackrest --stanza=postgres --type=incr backup

echo "Backup incremental finalizado"
echo "Detalles del backup:"
pgbackrest info