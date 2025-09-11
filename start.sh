#!/bin/sh
set -e

# Inicializa la base de datos de Superset
superset db upgrade
superset init

# Arranca Superset con Gunicorn
exec gunicorn -w 4 -k gthread --timeout 120 -b 0.0.0.0:8088 "superset.app:create_app"

