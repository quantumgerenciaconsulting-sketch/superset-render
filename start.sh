#!/bin/sh
set -e

# Esperar a que MySQL esté listo
echo "Esperando a que MySQL esté disponible..."
while ! nc -z superset_mysql 3306; do
  sleep 1
done

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

# Arrancar Superset (Gunicorn con mayor timeout)
exec gunicorn -w 1 -k gthread --threads 2 --timeout 300 \
  -b 0.0.0.0:8088 "superset.app:create_app()"
