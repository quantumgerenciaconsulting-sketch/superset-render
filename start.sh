#!/bin/sh
set -e

# Migraciones + inicialización
superset db upgrade
superset init

# Crea admin si no existe (no falla si ya existe)
superset fab create-admin \
  --username admin \
  --firstname Quantum \
  --lastname POS \
  --email admin@quantumpos.com.co \
  --password 1234 || true

# Arranca con menos workers para ahorrar RAM en Render Free
exec gunicorn -w 2 -k gthread --timeout 120 -b 0.0.0.0:8088 "superset.app:create_app()"
