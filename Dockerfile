FROM apache/superset:latest
SHELL ["/bin/sh", "-lc"]

USER root

# Variables de entorno
ENV PYTHONPATH="/app/pythonpath:${PYTHONPATH}"
RUN mkdir -p /app/pythonpath /app/superset/static/assets

# Instalar PyMySQL (driver MySQL) + Pillow + WeasyPrint
RUN if command -v uv >/dev/null 2>&1; then \
      . /app/.venv/bin/activate && uv pip install PyMySQL Pillow weasyprint; \
    else \
      /app/.venv/bin/pip install --no-cache-dir PyMySQL Pillow weasyprint; \
    fi

# Config Superset
COPY superset_config.py /app/pythonpath/superset_config.py

# Logos y favicons personalizados
COPY assets/quantum-bg.png /app/superset/static/assets/quantum-bg.png
COPY assets/Logoquantum.png /app/superset/static/assets/Logoquantum.png
COPY assets/Quantumsenial.png /app/superset/static/assets/Quantumsenial.png

# Permisos
RUN chmod 0644 /app/superset/static/assets/*.png

USER superset

# Script de arranque
COPY start.sh /start.sh

EXPOSE 8088
CMD ["sh", "/start.sh"]
