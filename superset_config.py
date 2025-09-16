# /app/pythonpath/superset_config.py

import os
import pymysql
pymysql.install_as_MySQLdb()

# ========= REDIS (tu URL real) =========
REDIS_URL = os.getenv(
    "REDIS_URL",
    "redis://default:lGS7NuMqCimKa8AOYQVKg7up8FM2ZurG@redis-12410.c14.us-east-1-3.ec2.redns.redis-cloud.com:12410/0"
)

# -------- Celery: broker + backend (Reports/Alerts, SQL Lab async) --------
class CeleryConfig:
    broker_url = REDIS_URL
    result_backend = REDIS_URL
    imports = ("superset.sql_lab",)
    broker_transport_options = {"visibility_timeout": 3600}
    task_ignore_result = True
    worker_concurrency = 1  # ajustado para entornos con poca RAM

CELERY_CONFIG = CeleryConfig

# -------- Caches y resultados usando Redis (mejor que memoria) --------
from cachelib.redis import RedisCache

CACHE_CONFIG = {
    "CACHE_TYPE": "RedisCache",
    "CACHE_REDIS_URL": REDIS_URL,
    "CACHE_KEY_PREFIX": "superset_",
    "CACHE_DEFAULT_TIMEOUT": 300,
}
DATA_CACHE_CONFIG = CACHE_CONFIG

# Resultados de SQL Lab (evita escribir en disco/SQLite)
RESULTS_BACKEND = RedisCache(
    host="redis-12410.c14.us-east-1-3.ec2.redns.redis-cloud.com",
    port=12410,
    password="lGS7NuMqCimKa8AOYQVKg7up8FM2ZurG",
    db=0,
    key_prefix="superset_results",
)

# Rate limiting sin warning (usa Redis en lugar de memoria)
RATELIMIT_STORAGE_URI = REDIS_URL  # elimina el warning de flask-limiter

# ========= FEATURE FLAGS =========
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

# ========= EMAIL (para Reports/Alerts) =========
EMAIL_NOTIFICATIONS = True
SMTP_HOST = "smtp.sendgrid.net"   # ajusta si usas otro proveedor
SMTP_STARTTLS = True
SMTP_SSL = False
SMTP_USER = "apikey"
SMTP_PORT = 587
SMTP_PASSWORD = "TU_API_KEY"      # <-- pon tu API Key real
SMTP_MAIL_FROM = "gerencia@quantumpos.com.co"

# ========= BRANDING =========
APP_NAME = "Quantum POS Analytics"
APP_ICON = "/static/assets/Logoquantum.png"       # login
LOGO_ICON = "/static/assets/Quantumsenial.png"    # barra superior izquierda
FAVICONS = [{"href": "/static/assets/Quantumsenial.png"}]
