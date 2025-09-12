#!/bin/sh
set -e

# (Opcional) Limpieza de metadata si lo necesitas de cero:
# rm -f /app/superset_home/superset.db || true

superset db upgrade
superset init

superset fab create-admin \
  --username admin \
  --firstname Quantum \
  --lastname POS \
  --email admin@quantumpos.com.co \
  --password 1234 || true

# Un solo worker en Render Free para ahorrar memoria
exec gunicorn -w 1 -k gthread --timeout 120 -b 0.0.0.0:8088 "superset.app:create_app()"
