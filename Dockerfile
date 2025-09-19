FROM apache/superset:latest
SHELL ["/bin/sh", "-lc"]

USER root

# Rutas útiles
ENV PYTHONPATH="/app/pythonpath:${PYTHONPATH}"
RUN mkdir -p /app/pythonpath /app/superset/static/assets

# Paquetes Python extra
RUN /app/.venv/bin/pip install --no-cache-dir PyMySQL Pillow weasyprint

# --- Headless Firefox + Geckodriver (necesarios para PNG/PDF de Reports) ---
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      firefox-esr wget curl ca-certificates xz-utils \
      libgtk-3-0 libdbus-glib-1-2 fonts-liberation \
      # libs para PDF con WeasyPrint
      libcairo2 libpango-1.0-0 libpangoft2-1.0-0 libgdk-pixbuf2.0-0 libffi8 \
      fonts-dejavu fonts-noto-core && \
    rm -rf /var/lib/apt/lists/*

# Instalar geckodriver (ajusta versión si quieres)
ENV GECKODRIVER_VERSION=0.34.0
RUN wget -O /tmp/geckodriver.tar.gz \
      https://github.com/mozilla/geckodriver/releases/download/v${GECKODRIVER_VERSION}/geckodriver-v${GECKODRIVER_VERSION}-linux64.tar.gz && \
    tar -C /usr/local/bin -xzf /tmp/geckodriver.tar.gz && \
    rm /tmp/geckodriver.tar.gz && \
    chmod +x /usr/local/bin/geckodriver

# Config y assets (si tengo los PNG, dejar estas 4 líneas)
COPY superset_config.py /app/pythonpath/superset_config.py
COPY assets/quantum-bg.png /app/superset/static/assets/quantum-bg.png
COPY assets/Logoquantum.png /app/superset/static/assets/Logoquantum.png
COPY assets/Quantumsenial.png /app/superset/static/assets/Quantumsenial.png
RUN chmod 0644 /app/superset/static/assets/*.png || true

# Script de arranque
USER superset
COPY start.sh /start.sh

EXPOSE 8088
CMD ["sh", "/start.sh"]
