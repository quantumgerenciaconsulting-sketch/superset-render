# /app/pythonpath/superset_config.py será cargado automáticamente por Superset

import pymysql
pymysql.install_as_MySQLdb()
from celery.schedules import crontab

# ===========================================
# FEATURE FLAGS
# ===========================================
FEATURE_FLAGS = {
    "ALERT_REPORTS": True,
    "DASHBOARD_NATIVE_FILTERS": True,
    "DASHBOARD_CROSS_FILTERS": True,
    "DASHBOARD_NATIVE_FILTERS_SET": True,
    "ALLOW_DASHBOARD_DOMAIN_SHARDING": True,
    "ENABLE_TEMPLATE_PROCESSING": True,
    "DISPLAY_MARKDOWN": True,
    "OMNIBAR": True,
    "DRILL_BY": True,
    "DRILL_TO_DETAIL": True,
    "HORIZONTAL_FILTER_BAR": True
}

# ===========================================
# EMAIL PARA REPORTES
# ===========================================
EMAIL_NOTIFICATIONS = True
SMTP_HOST = "smtp.sendgrid.net"
SMTP_STARTTLS = True
SMTP_SSL = False
SMTP_USER = "apikey"   # Usuario SMTP (ejemplo SendGrid)
SMTP_PORT = 587
SMTP_PASSWORD = "TU_API_KEY_O_PASSWORD"
SMTP_MAIL_FROM = "gerencia@quantumpos.com.co"

# ===========================================
# CELERY CONFIG
# ===========================================
class CeleryConfig:
    broker_url = "redis://redis:6379/0"
    result_backend = "redis://redis:6379/0"
    beat_schedule = {
        "reports.scheduler": {
            "task": "superset.tasks.scheduler.execute_periodic_tasks",
            "schedule": crontab(minute="*"),
        },
    }

CELERY_CONFIG = CeleryConfig
ALERT_REPORTS_NOTIFICATION_DRY_RUN = False  # Desactiva dry-run para enviar correos reales

# ===========================================
# BRANDING
# ===========================================
APP_NAME = "Quantum POS Analytics"
APP_ICON = "/static/assets/Logoquantum.png"
LOGO_ICON = "/static/assets/Quantumsenial.png"
FAVICONS = [{"href": "/static/assets/Quantumsenial.png"}]
