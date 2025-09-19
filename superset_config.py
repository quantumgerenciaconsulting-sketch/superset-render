import os
import pymysql
pymysql.install_as_MySQLdb()

# ========= REDIS =========
REDIS_URL = os.getenv("REDIS_URL", "redis://redis:6379/0")

class CeleryConfig:
    broker_url = REDIS_URL
    result_backend = REDIS_URL
    imports = ("superset.sql_lab",)  # + tareas internas
    broker_transport_options = {"visibility_timeout": 3600}
    task_ignore_result = True
    worker_concurrency = int(os.getenv("WORKER_CONCURRENCY", "2"))

CELERY_CONFIG = CeleryConfig

from cachelib.redis import RedisCache

CACHE_CONFIG = {
    "CACHE_TYPE": "RedisCache",
    "CACHE_REDIS_URL": REDIS_URL,
    "CACHE_KEY_PREFIX": "superset_",
    "CACHE_DEFAULT_TIMEOUT": 300,
}
DATA_CACHE_CONFIG = CACHE_CONFIG

RESULTS_BACKEND = RedisCache(
    host=os.getenv("REDIS_HOST", "redis"),
    port=int(os.getenv("REDIS_PORT", "6379")),
    db=0,
    key_prefix="superset_results",
)

RATELIMIT_STORAGE_URI = REDIS_URL

# ====== URL base ======
BASE_URL = os.getenv("BASE_URL", "http://127.0.0.1:8088")
ENABLE_PROXY_FIX = True

# ====== EMAIL / SMTP ======
EMAIL_NOTIFICATIONS = True
SMTP_HOST = os.getenv("SMTP_HOST", "mail.quantumpos.com.co")
SMTP_STARTTLS = os.getenv("SMTP_STARTTLS", "True") == "True"  # puerto 587
SMTP_SSL = os.getenv("SMTP_SSL", "False") == "True"           # puerto 465
SMTP_USER = os.getenv("SMTP_USER", "gerencia@quantumpos.com.co")
SMTP_PORT = int(os.getenv("SMTP_PORT", "587"))
SMTP_PASSWORD = os.getenv("SMTP_PASSWORD", "")
SMTP_MAIL_FROM = os.getenv("SMTP_MAIL_FROM", "gerencia@quantumpos.com.co")

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

# ====== BRANDING (opcional) ======
APP_NAME = "Quantum POS Analytics"
# APP_ICON = "/static/assets/Logoquantum.png"
# LOGO_ICON = "/static/assets/Quantumsenial.png"
# FAVICONS = [{"href": "/static/assets/Quantumsenial.png"}]
