FROM apache/superset:latest

# Para poder usar "source" del venv en RUN si hace falta
SHELL ["/bin/sh","-lc"]

USER root

# Que Superset cargue nuestro pythonpath
ENV PYTHONPATH="/app/pythonpath:${PYTHONPATH}"
RUN mkdir -p /app/pythonpath /app/superset/static/assets

# Driver MySQL (en el venv de Superset)
RUN if command -v uv >/dev/null 2>&1; then \
      . /app/.venv/bin/activate && uv pip install PyMySQL; \
    else \
      /app/.venv/bin/pip install --no-cache-dir PyMySQL; \
    fi

# Config de Superset (alias MySQLdb -> PyMySQL)
COPY superset_config.py /app/pythonpath/superset_config.py

# >>> NUEVO: copia tu logo a los estáticos del propio Superset
# Asegúrate de tener 'assets/quantum-bg.png' en tu repo
COPY assets/quantum-bg.png /app/superset/static/assets/quantum-bg.png
# (Opcional) si quieres asegurar permisos de lectura para el usuario 'superset':
# RUN chown superset:superset /app/superset/static/assets/quantum-bg.png

USER superset

# Script de arranque
COPY start.sh /start.sh

EXPOSE 8088
CMD ["sh", "/start.sh"]
