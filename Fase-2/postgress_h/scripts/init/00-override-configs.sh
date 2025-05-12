#!/bin/bash
echo "🔧 Sobrescribiendo configuraciones personalizadas..."
cp /custom-configs/postgresql.conf /bitnami/postgresql/conf/postgresql.conf
cp /custom-configs/repmgr.conf /bitnami/postgresql/conf/repmgr.conf
cp /custom-configs/pg_hba.conf /bitnami/postgresql/conf/pg_hba.conf