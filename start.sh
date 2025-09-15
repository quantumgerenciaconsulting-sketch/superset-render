#!/bin/sh
set -e

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

# Determinar qué proceso levantar (web o worker)
if [ "$1" = "worker" ]; then
  echo "Iniciando Celery worker para Alerts & Reports..."
  exec celery --app=superset.tasks.celery_app:app worker --pool=prefork -O fair -c 2
elif [ "$1" = "beat" ]; then
  echo "Iniciando Celery beat scheduler..."
  exec celery --app=superset.tasks.celery_app:app beat --scheduler celery.beat.PersistentScheduler --pidfile /tmp/celerybeat.pid
else
  echo "Iniciando servidor web de Superset..."
  # Render Free: un solo worker gunicorn para ahorrar memoria
  exec gunicorn -w 1 -k gthread --timeout 120 -b 0.0.0.0:8088 "superset.app:create_app()"
fi
