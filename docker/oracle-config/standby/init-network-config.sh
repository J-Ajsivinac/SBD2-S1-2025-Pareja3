#!/bin/bash

TARGET_DIR="/opt/oracle/oradata/dbconfig/${ORACLE_SID}"

echo "[INIT] Configurando archivos de red en $TARGET_DIR..."

mkdir -p "$TARGET_DIR"

for file in listener.ora sqlnet.ora tnsnames.ora; do
  if [ -f "/container-init-config/$file" ]; then
    cp -f "/container-init-config/$file" "$TARGET_DIR/$file"
    echo "[INIT] Copiado $file → $TARGET_DIR"
  else
    echo "[INIT] ⚠️ Advertencia: $file no encontrado en /container-init-config"
  fi
done

chmod 644 "$TARGET_DIR"/*.ora

echo "[INIT] Lanzando Oracle..."
/opt/oracle/runOracle.sh
