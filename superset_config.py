# /app/pythonpath/superset_config.py
import os

# Base URL pública (para generar links y screenshots)
BASE_URL = os.getenv("BASE_URL", "http://localhost:8088")

# --- Metastore (MySQL) ---
SQLALCHEMY_DATABASE_URI = os.getenv("SQLALCHEMY_DATABASE_URI")  # debe venir en .env
SQLALCHEMY_TRACK_MODIFICATIONS = False

# --- Redis / Celery ---
REDIS_URL = os.getenv("REDIS_URL")
CELERY_BROKER_URL = os.getenv("CELERY_BROKER_URL", REDIS_URL)
RESULT_BACKEND = os.getenv("RESULT_BACKEND", REDIS_URL)

class CeleryConfig:
    broker_url = CELERY_BROKER_URL
    result_backend = RESULT_BACKEND
    task_track_started = True
    worker_disable_rate_limits = True
    task_serializer = "json"
    accept_content = ["json"]
    result_serializer = "json"
    timezone = "America/Bogota"

CELERY_CONFIG = CeleryConfig

# --- Email (SMTP) ---
EMAIL_NOTIFICATIONS = os.getenv("EMAIL_NOTIFICATIONS", "True") == "True"
SMTP_HOST = os.getenv("SMTP_HOST")
SMTP_STARTTLS = os.getenv("SMTP_STARTTLS", "True") == "True"
SMTP_SSL = os.getenv("SMTP_SSL", "False") == "True"
SMTP_USER = os.getenv("SMTP_USER")
SMTP_PORT = int(os.getenv("SMTP_PORT", "587"))
SMTP_PASSWORD = os.getenv("SMTP_PASSWORD")
SMTP_MAIL_FROM = os.getenv("SMTP_MAIL_FROM", SMTP_USER)

# --- Llave secreta ---
SECRET_KEY = os.getenv("SECRET_KEY", "change-me")

# --- Reportes & Thumbnails / Selenium ---
FEATURE_FLAGS = {
    "ALERT_REPORTS": True,
}

# Usuario con permisos para tomar screenshots (debe existir)
THUMBNAIL_SELENIUM_USER = os.getenv("THUMBNAIL_SELENIUM_USER", os.getenv("ADMIN_USER", "admin"))
THUMBNAIL_SELENIUM_PASSWORD = os.getenv("THUMBNAIL_SELENIUM_PASSWORD")
THUMBNAIL_CACHE_CONFIG = {"CACHE_TYPE": "null"}  # opcional

WEBDRIVER_BASEURL = BASE_URL  # muy importante para que Selenium apunte al dominio correcto
WEBDRIVER_TYPE = "firefox"
WEBDRIVER_OPTION_ARGS = ["--headless", "--no-sandbox", "--disable-gpu", "--window-size=1920,1080"]
WEBDRIVER_WINDOW = {"width": 1920, "height": 1080}  # opcional

# Zona horaria para schedules
SUPERSET_WEBSERVER_TIMEOUT = 120
DEFAULT_TIME_FILTER = "Last week"

from flask_appbuilder.security.manager import AUTH_DB
AUTH_TYPE = AUTH_DB                # fuerza el login clásico (con vista /login)
RATELIMIT_ENABLED = False          # apaga el limiter global
AUTH_RATE_LIMITED = False          # apaga rate limit en /login
RATELIMIT_STORAGE_URI = None       # evita que FAB inicialice Limiter
AUTH_RATE_LIMIT = None

# ===== Branding (opcional) =====
APP_NAME = "Quantum POS Analytics"
APP_ICON = "/static/assets/Logoquantum.png"
LOGO_ICON = "/static/assets/Quantumsenial.png"
FAVICONS = [{"href": "/static/assets/Quantumsenial.png"}]
