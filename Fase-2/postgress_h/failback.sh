#!/bin/bash

# Soluciona el problema del usuario sin nombre
grep 1001 /etc/passwd || echo "repmgruser:x:1001:1001::/home/repmgruser:/bin/bash" >> /etc/passwd

while true; do
    sleep 1
    echo "[auto-failback] Verificando condiciones para failback..."

    IS_THIS_STANDBY=$(PGPASSWORD=replica_pass psql -U replica -h localhost -d repmgr -t -c \
        "SELECT type FROM repmgr.nodes WHERE node_name='master-1';" | xargs)

    IS_OTHER_PRIMARY=$(PGPASSWORD=replica_pass psql -U replica -h localhost -d repmgr -t -c \
        "SELECT type FROM repmgr.nodes WHERE node_name='slave-2';" | xargs)

    if [ "$IS_THIS_STANDBY" == "standby" ] && [ "$IS_OTHER_PRIMARY" == "primary" ]; then
        echo "[auto-failback] Condiciones cumplidas. Ejecutando switchover..."
        /opt/bitnami/postgresql/bin/repmgr -f /opt/bitnami/repmgr/conf/repmgr.conf standby switchover --force --no-ssh
        echo "[auto-failback] Switchover completado."
        break
    else
        echo "[auto-failback] No listo. Este nodo: $IS_THIS_STANDBY, slave-2: $IS_OTHER_PRIMARY"
    fi
done
