#!/bin/sh
set -e

# (Opcional) limpiar base si quieres empezar de cero
# rm -f /app/superset_home/superset.db || true

# Migraciones y setup inicial
superset db upgrade
superset init

# Crear admin si no existe
superset fab create-admin \
  --username admin \
  --firstname Quantum \
  --lastname POS \
  --email admin@quantumpos.com.co \
  --password 1234 || true

# --- Arrancar los 3 procesos juntos ---

# 1. Superset Web (Gunicorn)
gunicorn -w 1 -k gthread --timeout 120 -b 0.0.0.0:8088 "superset.app:create_app()" &

# 2. Celery Worker
celery --app=superset.tasks.celery_app:app worker \
  --pool=prefork -O fair -c 2 &

# 3. Celery Beat (scheduler)
celery --app=superset.tasks.celery_app:app beat \
  --scheduler celery.beat.PersistentScheduler \
  --pidfile /tmp/celerybeat.pid &

# Mantener el contenedor vivo esperando el primer proceso que termine
wait -n
