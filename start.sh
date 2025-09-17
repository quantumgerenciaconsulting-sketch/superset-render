#!/bin/sh
set -e

# Migraciones metadata Superset
superset db upgrade

# Crear admin si no existe
superset fab create-admin \
  --username admin \
  --firstname Admin \
  --lastname User \
  --email admin@quantumpos.com.co \
  --password admin || true

# Cargar roles, permisos y defaults
superset init

# Celery Worker (1 proceso, sin prefork pesado)
celery --app=superset.tasks.celery_app:app worker \
  --concurrency=1 -O fair -P solo &

# Celery Beat (schedule en /tmp para evitar permisos)
celery --app=superset.tasks.celery_app:app beat \
  --scheduler celery.beat.PersistentScheduler \
  --pidfile /tmp/celerybeat.pid \
  --schedule /tmp/celerybeat-schedule.db &

# Arrancar Superset (Gunicorn) con 1 worker y 2 hilos
exec gunicorn -w 1 -k gthread --threads 2 --timeout 120 \
  -b 0.0.0.0:8088 "superset.app:create_app()"
