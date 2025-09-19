#!/bin/sh
set -e

# Migraciones DB
/app/.venv/bin/superset db upgrade

# Crear admin si no existe
/app/.venv/bin/superset fab create-admin \
  --username admin \
  --firstname Admin \
  --lastname User \
  --email admin@quantumpos.com.co \
  --password admin || true

# Inicializar
/app/.venv/bin/superset init

# Arrancar Superset (Gunicorn)
exec gunicorn -w 1 -k gthread --threads 2 --timeout 120 \
  -b 0.0.0.0:8088 "superset.app:create_app()"
