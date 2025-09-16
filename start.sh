#!/bin/sh
set -e

# Migraciones y setup inicial
superset db upgrade
superset init

# Crear usuario admin (solo primera vez, luego ignora)
superset fab create-admin \
  --username admin \
  --firstname Quantum \
  --lastname POS \
  --email admin@quantumpos.com.co \
  --password 1234 || true

# Procesos secundarios en background
celery --app=superset.tasks.celery_app:app worker --pool=prefork -O fair -c 2 &
celery --app=superset.tasks.celery_app:app beat --scheduler celery.beat.PersistentScheduler --pidfile /tmp/celerybeat.pid &

# Proceso principal (Render se queda con este)
exec gunicorn -w 1 -k gthread --timeout 120 -b 0.0.0.0:8088 "superset.app:create_app()"
