#!/bin/sh
set -e

# Migraciones metadata Superset
superset db upgrade

# Crear admin si no existe
superset fab create-admin \
  --username admin \
  --firstname Admin \
  --lastname User \
  --email admin@quantumpos.com.co \
  --password admin || true

# Roles/permiso/semillas
superset init

# App web
exec gunicorn -w 1 -k gthread --threads 2 --timeout 120 \
  -b 0.0.0.0:8088 "superset.app:create_app()"
