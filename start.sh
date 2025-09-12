#!/bin/sh
set -e

# Configuración adicional de variables de entorno
export SUPERSET_CONFIG_PATH=/app/pythonpath/superset_config.py

# Crear configuración si no existe
cat > /app/pythonpath/superset_config.py << EOF
FEATURE_FLAGS = {
    "ENABLE_TEMPLATE_PROCESSING": True
}
SQLALCHEMY_DATABASE_URI = "mysql+pymysql://root:y7%3FW40zE7y@app.quantumpos.com.co:3306/nexopos"
EOF

echo ">>> Iniciando setup de Superset..."

# Inicialización de la base de datos
superset db upgrade
superset init

# Crear usuario admin si no existe
superset fab create-admin \
  --username admin \
  --firstname Quantum \
  --lastname POS \
  --email admin@quantumpos.com.co \
  --password 1234 || true

echo ">>> Iniciando servidor..."
exec gunicorn -w 1 -k gthread --timeout 120 -b 0.0.0.0:8088 "superset.app:create_app()"
