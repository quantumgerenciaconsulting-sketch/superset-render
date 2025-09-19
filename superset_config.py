import os
import pymysql
pymysql.install_as_MySQLdb()

# ========= REDIS =========
REDIS_URL = os.getenv(
    "REDIS_URL",
    "redis://default:PASS@redis-12410.c14.us-east-1-3.ec2.redns.redis-cloud.com:12410/0"
)

# Celery config
class CeleryConfig:
    broker_url = REDIS_URL
    result_backend = REDIS_URL
    imports = ("superset.sql_lab", "superset.tasks.schedules")
    broker_transport_options = {"visibility_timeout": 3600}
    task_ignore_result = True
    worker_concurrency = 1

CELERY_CONFIG = CeleryConfig

# Beat usando redbeat
CELERY_BEAT_SCHEDULE = {}
beat_scheduler = "redbeat.RedBeatScheduler"

# Cache
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
    password="PASS",
    db=0,
    key_prefix="superset_results"
)
RATELIMIT_STORAGE_URI = REDIS_URL

# URL base
BASE_URL = os.getenv("BASE_URL", "https://analytics.quantumpos.com.co")
ENABLE_PROXY_FIX = True

# ====== EMAIL ======
EMAIL_NOTIFICATIONS = True
SMTP_HOST = os.getenv("SMTP_HOST", "smtp.gmail.com")
SMTP_STARTTLS = True
SMTP_SSL = False
SMTP_USER = os.getenv("SMTP_USER", "gerencia@quantumpos.com.co")
SMTP_PORT = 587
SMTP_PASSWORD = os.getenv("SMTP_PASSWORD", "APP_PASSWORD_GENERADA")
SMTP_MAIL_FROM = os.getenv("SMTP_MAIL_FROM", "gerencia@quantumpos.com.co")

# ====== DB MySQL ======
SQLALCHEMY_DATABASE_URI = os.getenv(
    "SQLALCHEMY_DATABASE_URI",
    "mysql+pymysql://superset:CambiaEstaClaveSuperset!!@superset_mysql:3306/superset_db"
)

# Features
FEATURE_FLAGS = {
    "ALERT_REPORTS": True,
    "DASHBOARD_NATIVE_FILTERS": True,
    "ENABLE_TEMPLATE_PROCESSING": True,
}
