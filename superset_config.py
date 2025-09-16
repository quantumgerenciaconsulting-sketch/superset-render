# /app/pythonpath/superset_config.py será cargado automáticamente por Superset

import pymysql
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
SMTP_HOST = "smtp.sendgrid.net"          # Cambia por tu servidor SMTP real
SMTP_STARTTLS = True
SMTP_SSL = False
SMTP_USER = "apikey"                     # Usuario SMTP (SendGrid usa "apikey")
SMTP_PORT = 587
SMTP_PASSWORD = "TU_API_KEY_O_PASSWORD"  # API key o password SMTP
SMTP_MAIL_FROM = "gerencia@quantumpos.com.co"  # Remitente que verán los usuarios

# ===========================================
# CELERY CONFIG (NECESARIO PARA ALERTS & REPORTS)
# ===========================================
class CeleryConfig:
    broker_url = "redis://redis:6379/0"       # Redis como broker
    result_backend = "redis://redis:6379/0"   # Redis como backend de resultados

CELERY_CONFIG = CeleryConfig

# ===========================================
# BRANDING PERSONALIZADO
# ===========================================
APP_NAME = "Quantum POS Analytics"

# Ícono en login
APP_ICON = "/static/assets/Logoquantum.png"

# Logo en la parte superior izquierda
LOGO_ICON = "/static/assets/Quantumsenial.png"

# Favicon en la pestaña del navegador
FAVICONS = [{"href": "/static/assets/Quantumsenial.png"}]

