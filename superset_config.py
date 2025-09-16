# /app/pythonpath/superset_config.py será cargado automáticamente por Superset

import os
import pymysql
from celery.schedules import crontab

# Forzar que cualquier import a MySQLdb use PyMySQL
pymysql.install_as_MySQLdb()

# ===========================================
# FEATURE FLAGS (activar plugins y vistas)
# ===========================================
FEATURE_FLAGS = {
    "ALERT_REPORTS": True,               # Habilita Alerts & Reports
    "DASHBOARD_NATIVE_FILTERS": True,    # Filtros nativos
    "DASHBOARD_CROSS_FILTERS": True,     # Cross-filters
    "DASHBOARD_NATIVE_FILTERS_SET": True,
    "ALLOW_DASHBOARD_DOMAIN_SHARDING": True,
    "ENABLE_TEMPLATE_PROCESSING": True,  # Variables {{ }} en SQL
    "DISPLAY_MARKDOWN": True,            # Chart Markdown
    "OMNIBAR": True,                     # Barra de búsqueda global
    "DRILL_BY": True,                    # Drill down
    "DRILL_TO_DETAIL": True,             # Drill to detail
    "HORIZONTAL_FILTER_BAR": True        # Barra de filtros horizontal
}

# ===========================================
# CONFIGURACIÓN DE EMAIL PARA REPORTES
# ===========================================
EMAIL_NOTIFICATIONS = True
SMTP_HOST = "smtp.sendgrid.net"
SMTP_STARTTLS = True
SMTP_SSL = False
SMTP_USER = "apikey"                     # Usuario SMTP (SendGrid usa "apikey")
SMTP_PORT = 587
SMTP_PASSWORD = "TU_API_KEY_O_PASSWORD"  # Reemplázalo por tu API Key real
SMTP_MAIL_FROM = "gerencia@quantumpos.com.co"

# ===========================================
# CELERY CONFIG (con Redis Cloud)
# ===========================================
# Render/Redis Cloud → define REDIS_URL en las env vars
# Ejemplo: rediss://default:<password>@redis-12410.c14.us-east-1-3.ec2.redns.redis-cloud.com:12410
REDIS_URL = os.environ.get("REDIS_URL", "redis://localhost:6379/0")

class CeleryConfig:
    broker_url = REDIS_URL
    result_backend = REDIS_URL
    beat_schedule = {
        "reports.scheduler": {
            "task": "superset.tasks.scheduler.execute_periodic_tasks",
            "schedule": crontab(minute="*"),
        },
    }

CELERY_CONFIG = CeleryConfig
ALERT_REPORTS_NOTIFICATION_DRY_RUN = False  # False = enviar correos reales

# ===========================================
# BRANDING PERSONALIZADO
# ===========================================
APP_NAME = "Quantum POS Analytics"

# Ícono en login
APP_ICON = "/static/assets/Logoquantum.png"

# Logo en la parte superior izquierda (reemplaza el de Superset)
LOGO_ICON = "/static/assets/Quantumsenial.png"

# Favicon en la pestaña del navegador
FAVICONS = [{"href": "/static/assets/Quantumsenial.png"}]

