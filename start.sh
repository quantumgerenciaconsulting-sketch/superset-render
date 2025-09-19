#!/bin/sh
set -e

# Modo worker de Celery
if [ "$1" = "worker" ]; then
  exec celery --app=superset.tasks.celery_app:app worker -O fair -c 2
fi

# Modo beat (scheduler de Celery)
if [ "$1" = "beat" ]; then
  exec celery --app=superset.tasks.celery_app:app beat \
    --scheduler celery.beat.PersistentScheduler \
    --pidfile /tmp/celerybeat.pid \
    --schedule /tmp/celerybeat-schedule.db
fi

# Modo web (Superset)
superset db upgrade

# Crea usuario admin si no existe (idempotente)
superset fab create-admin \
  --username admin \
  --firstname Admin \
  --lastname User \
  --email admin@quantumpos.com.co \
  --password admin || true

# Sincroniza roles y permisos
superset init

# Arranque del servidor web con Gunicorn
exec gunicorn -w 1 -k gthread --threads 2 --timeout 120 \
  -b 0.0.0.0:8088 "superset.app:create_app()"
