#!/bin/bash
# /scripts/backup_diff.sh
# Script para realizar backup diferencial

pgbackrest --stanza=postgres --type=diff backup

echo "Backup diferencial finalizado"
echo "Detalles del backup:"
pgbackrest info