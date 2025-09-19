#!/bin/sh
set -e

# Modo worker Celery
if [ "$1" = "worker" ]; then
  exec celery --app=superset.tasks.celery_app:app worker -O fair -c 2
fi

# Modo beat (scheduler)
if [ "$1" = "beat" ]; then
  exec celery --app=superset.tasks.celery_app:app beat \
    --scheduler celery.beat.PersistentScheduler \
    --pidfile /tmp/celerybeat.pid \
    --schedule /tmp/celerybeat-schedule.db
fi

# Modo web (Superset)
superset db upgrade

# Crear admin si no existe (no falla si ya existe)
superset fab create-admin \
  --username admin \
  --firstname Admin \
  --lastname User \
  --email admin@quantumpos.com.co \
  --password admin || true

# Sincroniza roles/Permisos
superset init

# Arranca Gunicorn
exec gunicorn -w 1 -k gthread --threads 2 --timeout 120 \
  -b 0.0.0.0:8088 "superset.app:create_app()"
