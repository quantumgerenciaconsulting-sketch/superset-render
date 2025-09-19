#!/bin/sh
set -e

# --- Modo worker Celery ---
if [ "$1" = "worker" ]; then
  exec celery --app=superset.tasks.celery_app:app worker -O fair -c 2
fi

# --- Modo beat (scheduler) ---
if [ "$1" = "beat" ]; then
  # Usamos ruta persistente con permisos del usuario 'superset'
  exec celery --app=superset.tasks.celery_app:app beat \
    --scheduler celery.beat.PersistentScheduler \
    --pidfile /var/lib/superset/celery/celerybeat.pid \
    --schedule /var/lib/superset/celery/celerybeat-schedule.db
fi

# --- Modo web (Superset) ---
# Migraciones e init (no tocan si ya está hecho)
superset db upgrade || true

superset fab create-admin \
  --username admin \
  --firstname Admin \
  --lastname User \
  --email admin@quantumpos.com.co \
  --password admin || true

superset init || true

# Arranca Gunicorn
exec gunicorn -w 1 -k gthread --threads 2 --timeout 120 \
  -b 0.0.0.0:8088 "superset.app:create_app()"
