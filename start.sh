#!/bin/sh
set -e

superset db upgrade
superset init

superset fab create-admin \
  --username admin \
  --firstname Quantum \
  --lastname POS \
  --email gerencia@quantumpos.com.co \
  --password 1234 || true

# Arrancar procesos secundarios (worker y beat)
celery --app=superset.tasks.celery_app:app worker --pool=prefork -O fair -c 2 &
celery --app=superset.tasks.celery_app:app beat --scheduler celery.beat.PersistentScheduler --pidfile /tmp/celerybeat.pid &

# Este es el proceso principal (Gunicorn)
exec gunicorn -w 1 -k gthread --timeout 120 -b 0.0.0.0:8088 "superset.app:create_app()"
