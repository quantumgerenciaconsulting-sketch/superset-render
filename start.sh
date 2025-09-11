#!/bin/sh
set -e

# Inicializa la base de datos de Superset
superset db upgrade
superset init

# Arranca Superset con Gunicorn apuntando al WSGI app correcto
exec gunicorn -w 4 -k gthread --timeout 120 -b 0.0.0.0:8088 superset.app:wsgi_app
