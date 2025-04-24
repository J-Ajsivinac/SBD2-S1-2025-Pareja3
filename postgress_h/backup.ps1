Write-Host "[🟡] Iniciando backup WAL-G desde contenedor 'master'..."

docker exec -u 0 master bash -c "
  export WALG_FILE_PREFIX=/bitnami/postgresql/wal_backups &&
  export WALG_DELTA_MAX_STEPS=5 &&
  export PGUSER=postgres &&
  export PGPASSWORD=postgres &&
  wal-g backup-push /bitnami/postgresql/data
"

Write-Host "[✅] Backup finalizado."
Write-Host "Puedes verificar con:"
Write-Host "docker exec -u 0 master bash -c 'export WALG_FILE_PREFIX=/bitnami/postgresql/wal_backups && wal-g backup-list'"
