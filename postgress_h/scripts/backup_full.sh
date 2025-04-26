
#!/bin/bash
# /scripts/backup_full.sh
# Script para realizar backup completo

pgbackrest --stanza=postgres --type=full backup

echo "Backup completo finalizado"
echo "Detalles del backup:"
pgbackrest info
