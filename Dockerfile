FROM apache/superset:latest
SHELL ["/bin/sh","-lc"]

USER root

# Que Superset cargue nuestro pythonpath y crear carpetas necesarias
ENV PYTHONPATH="/app/pythonpath:${PYTHONPATH}"
RUN mkdir -p /app/pythonpath /app/superset/static/assets

# Instalar PyMySQL y extras dentro del entorno correcto (uv o venv)
RUN if command -v uv >/dev/null 2>&1; then \
      . /app/.venv/bin/activate && uv pip install PyMySQL psycopg2-binary redis celery weasyprint; \
    else \
      /app/.venv/bin/pip install --no-cache-dir PyMySQL psycopg2-binary redis celery weasyprint; \
    fi

# Configuración (superset_config con branding personalizado)
COPY superset_config.py /app/pythonpath/superset_config.py

# Logo personalizado
COPY assets/quantum-bg.png /app/superset/static/assets/quantum-bg.png
RUN chmod 0644 /app/superset/static/assets/quantum-bg.png

# (Opcional) asignar propiedad al usuario superset
# RUN chown -R superset:superset /app/pythonpath /app/superset/static/assets

USER superset

# Script de arranque
COPY start.sh /start.sh

EXPOSE 8088
CMD ["sh", "/start.sh"]
