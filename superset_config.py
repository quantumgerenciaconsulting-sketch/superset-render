# /app/pythonpath/superset_config.py será cargado automáticamente por Superset
import pymysql
pymysql.install_as_MySQLdb()

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
    "HORIZONTAL_FILTER_BAR": True,
}

# ===========================================
# CONFIGURACIÓN DE EMAIL PARA REPORTES
# ===========================================
EMAIL_NOTIFICATIONS = True
SMTP_HOST = "smtp.sendgrid.net"
SMTP_STARTTLS = True
SMTP_SSL = False
SMTP_USER = "apikey"     # Cambiar si usas otro SMTP
SMTP_PORT = 587
SMTP_PASSWORD = "TU_API_KEY_O_PASSWORD"
SMTP_MAIL_FROM = "gerencia@quantumpos.com.co"

# ===========================================
# CELERY (Redis Cloud URL)
# ===========================================
class CeleryConfig:
    broker_url = "redis://default:lGS7NuMqCimKa8AOYQVKg7up8FM2ZurG@redis-12410.c14.us-east-1-3.ec2.redns.redis-cloud.com:12410/0"
    result_backend = broker_url
    imports = ("superset.sql_lab",)
    beat_scheduler = "celery.beat.PersistentScheduler"

CELERY_CONFIG = CeleryConfig

# ===========================================
# BRANDING PERSONALIZADO
# ===========================================
APP_NAME = "Quantum POS Analytics"

# Ícono en login
APP_ICON = "/static/assets/Logoquantum.png"

# Logo arriba a la izquierda
LOGO_ICON = "/static/assets/Quantumsenial.png"

# Favicon en pestaña navegador
FAVICONS = [{"href": "/static/assets/Quantumsenial.png"}]
