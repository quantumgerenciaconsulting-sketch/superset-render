# Usa Superset 5.x (latest al día)
FROM apache/superset:latest
SHELL ["/bin/sh", "-lc"]

USER root

# RUTA para configs custom
ENV PYTHONPATH="/app/pythonpath:${PYTHONPATH}"
RUN mkdir -p /app/pythonpath /app/superset/static/assets

# Dependencias Python (drivers + pdf/png)
RUN /app/.venv/bin/pip install --no-cache-dir PyMySQL Pillow weasyprint

# ---- Headless Firefox + Geckodriver ----
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      firefox-esr wget ca-certificates xz-utils \
      libgtk-3-0 libdbus-glib-1-2 fonts-liberation \
      libasound2 libnss3 libx11-xcb1 libxtst6 libxrender1 libxi6 && \
    rm -rf /var/lib/apt/lists/*

ENV GECKODRIVER_VERSION=0.34.0
RUN wget -O /tmp/geckodriver.tar.gz \
      https://github.com/mozilla/geckodriver/releases/download/v${GECKODRIVER_VERSION}/geckodriver-v${GECKODRIVER_VERSION}-linux64.tar.gz && \
    tar -C /usr/local/bin -xzf /tmp/geckodriver.tar.gz && \
    rm /tmp/geckodriver.tar.gz && \
    chmod +x /usr/local/bin/geckodriver

# Copia de configuración y assets (si los tienes)
COPY superset_config.py /app/pythonpath/superset_config.py
# (opcional) descomenta si tienes estos archivos:
# COPY assets/quantum-bg.png /app/superset/static/assets/quantum-bg.png
# COPY assets/Logoquantum.png /app/superset/static/assets/Logoquantum.png
# COPY assets/Quantumsenial.png /app/superset/static/assets/Quantumsenial.png
# RUN chmod 0644 /app/superset/static/assets/*.png || true

# Script de arranque del servicio web
COPY start.sh /start.sh
RUN chmod +x /start.sh

USER superset
EXPOSE 8088
CMD ["sh", "/start.sh"]
