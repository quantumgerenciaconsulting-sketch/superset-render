# /app/pythonpath/superset_config.py
import os
import pymysql
pymysql.install_as_MySQLdb()

# ========= REDIS (usa tu Redis Cloud o local si cambias luego) =========
REDIS_URL = os.getenv(
    "REDIS_URL",
    "redis://default:lGS7NuMqCimKa8AOYQVKg7up8FM2ZurG@redis-12410.c14.us-east-1-3.ec2.redns.redis-cloud.com:12410/0"
)

# ----- Celery (Reports/Alerts, SQL Lab async) -----
class CeleryConfig:
    broker_url = REDIS_URL
    result_backend = REDIS_URL
    imports = ("superset.sql_lab",)
    broker_transport_options = {"visibility_timeout": 3600}
    task_ignore_result = True
    worker_concurrency = 1   # ahorra RAM

CELERY_CONFIG = CeleryConfig

# ----- Caches y resultados usando Redis -----
from cachelib.redis import RedisCache

CACHE_CONFIG = {
    "CACHE_TYPE": "RedisCache",
    "CACHE_REDIS_URL": REDIS_URL,
    "CACHE_KEY_PREFIX": "superset_",
    "CACHE_DEFAULT_TIMEOUT": 300,
}
DATA_CACHE_CONFIG = CACHE_CONFIG

RESULTS_BACKEND = RedisCache(
    host="redis-12410.c14.us-east-1-3.ec2.redns.redis-cloud.com",
    port=12410,
    password="lGS7NuMqCimKa8AOYQVKg7up8FM2ZurG",
    db=0,
    key_prefix="superset_results",
)

# Rate limits sin warning
RATELIMIT_STORAGE_URI = REDIS_URL

# ====== URL base para generar links correctos en correos ======
BASE_URL = os.getenv("BASE_URL", "http://127.0.0.1:8088")
ENABLE_PROXY_FIX = True   # importante si vas detrás de Nginx

# ====== EMAIL (para Reports/Alerts) ======
EMAIL_NOTIFICATIONS = True
SMTP_HOST = os.getenv("SMTP_HOST", "smtp.sendgrid.net")
SMTP_STARTTLS = os.getenv("SMTP_STARTTLS", "True") == "True"
SMTP_SSL = os.getenv("SMTP_SSL", "False") == "True"
SMTP_USER = os.getenv("SMTP_USER", "apikey")
SMTP_PORT = int(os.getenv("SMTP_PORT", "587"))
SMTP_PASSWORD = os.getenv("SMTP_PASSWORD", "TU_API_KEY")   # cámbialo por env
SMTP_MAIL_FROM = os.getenv("SMTP_MAIL_FROM", "gerencia@quantumpos.com.co")

# ====== Opcional: metadata de Superset en MySQL (mejor que SQLite) ======
# Déjalo a través de variable de entorno:
# SQLALCHEMY_DATABASE_URI = os.getenv("SQLALCHEMY_DATABASE_URI")

# ====== FEATURES ======
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

# ====== BRANDING ======
APP_NAME = "Quantum POS Analytics"
APP_ICON = "/static/assets/Logoquantum.png"
LOGO_ICON = "/static/assets/Quantumsenial.png"
FAVICONS = [{"href": "/static/assets/Quantumsenial.png"}]

