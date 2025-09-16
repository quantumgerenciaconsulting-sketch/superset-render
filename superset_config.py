import pymysql
pymysql.install_as_MySQLdb()

# ========= REDIS (para Celery/Cache) =========
REDIS_URL = "redis://default:TU_PASSWORD@redis-xxxx.c14.us-east-1-3.ec2.redns.redis-cloud.com:12410/0"

class CeleryConfig:
    broker_url = REDIS_URL
    result_backend = REDIS_URL
    imports = ("superset.sql_lab",)
    worker_concurrency = 1

CELERY_CONFIG = CeleryConfig

# ========= FEATURE FLAGS =========
FEATURE_FLAGS = {
    "ALERT_REPORTS": True,
    "DASHBOARD_NATIVE_FILTERS": True,
    "DASHBOARD_CROSS_FILTERS": True,
    "DRILL_BY": True,
    "DRILL_TO_DETAIL": True,
    "HORIZONTAL_FILTER_BAR": True,
}

# ========= EMAIL =========
EMAIL_NOTIFICATIONS = True
SMTP_HOST = "smtp.sendgrid.net"
SMTP_STARTTLS = True
SMTP_SSL = False
SMTP_USER = "apikey"
SMTP_PORT = 587
SMTP_PASSWORD = "TU_API_KEY"
SMTP_MAIL_FROM = "gerencia@quantumpos.com.co"

# ========= BRANDING =========
APP_NAME = "Quantum POS Analytics"
APP_ICON = "/static/assets/Logoquantum.png"
LOGO_ICON = "/static/assets/Quantumsenial.png"
FAVICONS = [{"href": "/static/assets/Quantumsenial.png"}]
