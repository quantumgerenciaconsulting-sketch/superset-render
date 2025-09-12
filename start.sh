#!/bin/sh
set -e

echo ">>> Reseteando metadata interna de Superset..."

# Elimina base interna vieja
rm -f /app/superset_home/superset.db || true

# Reconstruye metadata limpia
superset db upgrade
superset init

# Crea admin (si no existe)
superset fab create-admin \
  --username admin \
  --firstname Quantum \
  --lastname POS \
  --email admin@quantumpos.com.co \
  --password 1234 || true

echo ">>> Metadata lista, arrancando Gunicorn..."

# Arranca Gunicorn con menos workers para ahorrar RAM
exec gunicorn -w 1 -k gthread --timeout 120 -b 0.0.0.0:8088 "superset.app:create_app()"
