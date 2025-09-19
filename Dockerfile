# Dockerfile
FROM apache/superset:latest
SHELL ["/bin/sh", "-lc"]

# --- root para instalar dependencias del navegador y utilidades ---
USER root

ENV PYTHONPATH="/app/pythonpath:${PYTHONPATH}"

# Dependencias de Firefox/Selenium + fuentes
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      firefox-esr wget ca-certificates xz-utils \
      libgtk-3-0 libdbus-glib-1-2 libasound2 \
      libnss3 libxrandr2 libxtst6 libx11-xcb1 \
      libxcomposite1 libxdamage1 libxkbcommon0 \
      fonts-dejavu fonts-liberation && \
    rm -rf /var/lib/apt/lists/*

# Geckodriver
ENV GECKODRIVER_VERSION=0.34.0
RUN wget -O /tmp/geckodriver.tar.gz \
      https://github.com/mozilla/geckodriver/releases/download/v${GECKODRIVER_VERSION}/geckodriver-v${GECKODRIVER_VERSION}-linux64.tar.gz && \
    tar -C /usr/local/bin -xzf /tmp/geckodriver.tar.gz && \
    rm /tmp/geckodriver.tar.gz && \
    chmod +x /usr/local/bin/geckodriver

# Librerías Python útiles (opcional)
RUN /app/.venv/bin/pip install --no-cache-dir PyMySQL Pillow weasyprint

# Directorios que usaremos y permisos para celery beat
RUN mkdir -p /app/pythonpath /app/superset_home /var/lib/superset/celery && \
    chown -R superset:superset /app/pythonpath /app/superset_home /var/lib/superset

# Config y assets (si no tienes los PNG, elimina estas 4 líneas)
COPY superset_config.py /app/pythonpath/superset_config.py
COPY assets/quantum-bg.png /app/superset/static/assets/quantum-bg.png
COPY assets/Logoquantum.png /app/superset/static/assets/Logoquantum.png
COPY assets/Quantumsenial.png /app/superset/static/assets/Quantumsenial.png
RUN chmod 0644 /app/superset/static/assets/*.png || true

# Copiamos config y script de arranque
COPY superset_config.py /app/pythonpath/superset_config.py
COPY start.sh /start.sh
RUN chmod 0755 /start.sh && chown superset:superset /start.sh

# Volvemos al usuario "superset" del contenedor oficial
USER superset

EXPOSE 8088
CMD ["sh", "/start.sh"]


