#!/bin/sh
set -e

superset db upgrade
superset init
superset fab create-admin \
  --username admin \
  --firstname Quantum \
  --lastname POS \
  --email admin@quantumpos.com \
  --password 1234 || true

exec superset run -p 8088 --host 0.0.0.0

