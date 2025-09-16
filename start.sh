#!/bin/sh
set -e

# Inicializar la BD de superset
superset db upgrade

# Crear usuario admin si no existe
superset fab create-admin \
    --username admin \
    --firstname Admin \
    --lastname User \
    --email admin@quantumpos.com.co \
    --password admin || true

# Cargar roles y datasources
superset init

# Arrancar Celery Worker con 1 proceso y sin fork pesado
celery --app=superset.tasks.celery_app:app worker \
    --concurrency=1 -O fair -P solo &

# Arrancar Celery Beat con schedule en /tmp (evita permisos)
celery --app=superset.tasks.celery_app:app beat \
    --scheduler celery.beat.PersistentScheduler \
    --pidfile /tmp/celerybeat.pid \
    --schedule /tmp/celerybeat-schedule.db &

# Arrancar Superset (Gunicorn) con 1 worker y 2 threads
exec gunicorn -w 1 -k gthread --threads 2 --timeout 120 \
    -b 0.0.0.0:8088 "superset.app:create_app()"
