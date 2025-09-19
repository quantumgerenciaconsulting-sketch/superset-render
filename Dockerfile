FROM apache/superset:latest
SHELL ["/bin/sh", "-lc"]

USER root

ENV PYTHONPATH="/app/pythonpath:${PYTHONPATH}"
RUN mkdir -p /app/pythonpath /app/superset/static/assets

# Drivers y librerías extra
RUN /app/.venv/bin/pip install --no-cache-dir \
      PyMySQL \
      Pillow \
      weasyprint \
      redbeat

# --- Headless Firefox + Geckodriver ---
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      firefox-esr wget ca-certificates xz-utils \
      libgtk-3-0 libdbus-glib-1-2 fonts-liberation && \
    rm -rf /var/lib/apt/lists/*

ENV GECKODRIVER_VERSION=0.34.0
RUN wget -O /tmp/geckodriver.tar.gz \
      https://github.com/mozilla/geckodriver/releases/download/v${GECKODRIVER_VERSION}/geckodriver-v${GECKODRIVER_VERSION}-linux64.tar.gz && \
    tar -C /usr/local/bin -xzf /tmp/geckodriver.tar.gz && \
    rm /tmp/geckodriver.tar.gz && \
    chmod +x /usr/local/bin/geckodriver

# Config y assets
COPY superset_config.py /app/pythonpath/superset_config.py
COPY start.sh /start.sh
RUN chmod +x /start.sh

USER superset

EXPOSE 8088
CMD ["sh", "/start.sh"]
