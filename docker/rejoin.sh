#!/bin/bash

sleep 10

if repmgr cluster show | grep -q "primary"; then
  echo "Otro nodo es el nuevo primary. Reiniciando como standby..."
  gosu postgres pg_ctl stop -D /bitnami/postgresql/data --wait
  rm -rf /bitnami/postgresql/data
  repmgr -h postgresql-slave -U replica -d app_db -f /opt/bitnami/repmgr/conf/repmgr.conf standby clone --force
  /opt/bitnami/scripts/postgresql-repmgr/entrypoint.sh /opt/bitnami/scripts/postgresql-repmgr/run.sh
else
  echo "Soy el nuevo primary o el único nodo vivo. Iniciando normalmente..."
  exec /opt/bitnami/scripts/postgresql-repmgr/entrypoint.sh /opt/bitnami/scripts/postgresql-repmgr/run.sh
fi
