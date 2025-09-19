# /app/pythonpath/superset_config.py
import os
import pymysql
pymysql.install_as_MySQLdb()

from celery.schedules import crontab
from cachelib.redis import RedisCache

# ===== Redis (broker/resultados) =====
REDIS_URL = os.getenv(
    "REDIS_URL",
    "redis://default:lGS7NuMqCimKa8AOYQVKg7up8FM2ZurG@redis-12410.c14.us-east-1-3.ec2.redns.redis-cloud.com:12410/0",
)

# ===== Celery (Reports/Alerts, SQL Lab async) =====
class CeleryConfig:
    broker_url = REDIS_URL
    result_backend = REDIS_URL
    # Importa también tasks de reports (Superset 5)
    imports = ("superset.sql_lab", "superset.tasks.reports")
    broker_transport_options = {"visibility_timeout": 3600}
    task_ignore_result = True
    worker_concurrency = 1

    # Programación de reports
    beat_schedule = {
        "reports_scheduler": {
            "task": "reports.scheduler",
            "schedule": crontab(minute="*", hour="*"),
        },
        "reports_prune_log": {
            "task": "reports.prune_log",
            "schedule": crontab(minute=0, hour=0),
        },
    }

CELERY_CONFIG = CeleryConfig

# ===== Cachés =====
CACHE_CONFIG = {
    "CACHE_TYPE": "RedisCache",
    "CACHE_REDIS_URL": REDIS_URL,
    "CACHE_KEY_PREFIX": "superset_",
    "CACHE_DEFAULT_TIMEOUT": 300,
}
DATA_CACHE_CONFIG = CACHE_CONFIG

# Resultados de consultas en Redis (no uses from_url en 5.0)
RESULTS_BACKEND = RedisCache(
    host="redis-12410.c14.us-east-1-3.ec2.redns.redis-cloud.com",
    port=12410,
    password="lGS7NuMqCimKa8AOYQVKg7up8FM2ZurG",
    db=0,
    key_prefix="superset_results",
)

RATELIMIT_STORAGE_URI = REDIS_URL

# ===== Base URL (links correctos en emails) =====
BASE_URL = os.getenv("BASE_URL", "http://127.0.0.1:8088")
ENABLE_PROXY_FIX = True

# ===== Email / SMTP =====
EMAIL_NOTIFICATIONS = True
SMTP_HOST = os.getenv("SMTP_HOST", "smtp.sendgrid.net")
SMTP_STARTTLS = os.getenv("SMTP_STARTTLS", "True") == "True"
SMTP_SSL = os.getenv("SMTP_SSL", "False") == "True"
SMTP_USER = os.getenv("SMTP_USER", "apikey")
SMTP_PORT = int(os.getenv("SMTP_PORT", "587"))
SMTP_PASSWORD = os.getenv("SMTP_PASSWORD", "CAMBIA_ESTA_CLAVE")
SMTP_MAIL_FROM = os.getenv("SMTP_MAIL_FROM", "gerencia@quantumpos.com.co")

# Si es True, NO envía emails (dry-run). Aquí lo tomamos del .env.
ALERT_REPORTS_NOTIFICATION_DRY_RUN = os.getenv(
    "ALERT_REPORTS_NOTIFICATION_DRY_RUN", "False"
) == "True"

# ===== Metadata: se obtiene de la variable de entorno =====
# SQLALCHEMY_DATABASE_URI = os.getenv("SQLALCHEMY_DATABASE_URI")

# ===== WebDriver (capturas PNG/PDF) =====
WEBDRIVER_TYPE = os.getenv("WEBDRIVER_TYPE", "firefox")
WEBDRIVER_BASEURL = os.getenv("WEBDRIVER_BASEURL", "http://superset_app:8088")
WEBDRIVER_BASEURL_USER_FRIENDLY = os.getenv("WEBDRIVER_BASEURL_USER_FRIENDLY", BASE_URL)
WEBDRIVER_OPTION_ARGS = ["--headless"]
SCREENSHOT_LOCATE_WAIT = 100
SCREENSHOT_LOAD_WAIT = 100

# ===== Feature flags =====
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

# ===== Branding (opcional) =====
APP_NAME = "Quantum POS Analytics"
APP_ICON = "/static/assets/Logoquantum.png"
LOGO_ICON = "/static/assets/Quantumsenial.png"
FAVICONS = [{"href": "/static/assets/Quantumsenial.png"}]
