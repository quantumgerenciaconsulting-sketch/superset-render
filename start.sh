#!/bin/sh
set -e

# --- Modo worker Celery ---
if [ "$1" = "worker" ]; then
  exec celery --app=superset.tasks.celery_app:app worker -O fair -c 2 -E
fi

# --- Modo beat (scheduler) ---
if [ "$1" = "beat" ]; then
  # Usamos ruta persistente con permisos del usuario 'superset'
  mkdir -p /var/lib/superset/celery
  chown -R superset:superset /var/lib/superset/celery
  exec celery --app=superset.tasks.celery_app:app beat \
    --scheduler celery.beat.PersistentScheduler \
    --pidfile /var/lib/superset/celery/celerybeat.pid \
    --schedule /var/lib/superset/celery/celerybeat-schedule.db
fi

# --- Modo web (Superset) ---
superset db upgrade || true

superset fab create-admin \
  --username "${ADMIN_USER:-admin}" \
  --firstname Admin \
  --lastname User \
  --email "${ADMIN_EMAIL:-quantum.gerencia.consulting@gmail.com}" \
  --password "${ADMIN_PASSWORD:-admin}" || true

superset init || true

exec gunicorn -w 1 -k gthread --threads 2 --timeout 120 \
  -b 0.0.0.0:8088 "superset.app:create_app()"
