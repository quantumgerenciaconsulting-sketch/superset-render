FROM apache/superset:latest
SHELL ["/bin/sh","-lc"]

USER root

# Que Superset cargue nuestro pythonpath y crear carpetas necesarias
ENV PYTHONPATH="/app/pythonpath:${PYTHONPATH}"
RUN mkdir -p /app/pythonpath /app/superset/static/assets

# Instalar PyMySQL (como ya hacías)
RUN if command -v uv >/dev/null 2>&1; then \
      . /app/.venv/bin/activate && uv pip install PyMySQL; \
    else \
      /app/.venv/bin/pip install --no-cache-dir PyMySQL; \
    fi

# Instalar dependencias extra para habilitar Reports/Alerts y más drivers
RUN /app/.venv/bin/pip install --no-cache-dir \
      mysqlclient \
      psycopg2-binary \
      redis \
      celery \
      weasyprint

# Configuración (alias MySQLdb -> PyMySQL)
COPY superset_config.py /app/pythonpath/superset_config.py

# Imagen para el fondo (ya la subiste al repo en assets/)
COPY assets/quantum-bg.png /app/superset/static/assets/quantum-bg.png
RUN chmod 0644 /app/superset/static/assets/quantum-bg.png

# (Opcional) asigna propiedad al usuario 'superset'
# RUN chown -R superset:superset /app/pythonpath /app/superset/static/assets

USER superset

# Script de arranque
COPY start.sh /start.sh

EXPOSE 8088
CMD ["sh", "/start.sh"]
