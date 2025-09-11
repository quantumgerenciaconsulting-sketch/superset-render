#!/bin/sh
set -e

# Inicializa la base de datos de Superset
superset db upgrade
superset init

# Crea usuario admin (si no existe)
superset fab create-admin \
    --username admin \
    --firstname Quantum \
    --lastname POS \
    --email admin@quantumpos.com \
    --password 1234 || true

# Arranca Superset con Gunicorn (menos workers para ahorrar memoria)
exec gunicorn -w 2 -k gthread --timeout 120 -b 0.0.0.0:8088 "superset.app:create_app()"
