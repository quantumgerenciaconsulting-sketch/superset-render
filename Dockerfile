FROM apache/superset:latest
SHELL ["/bin/sh","-lc"]

USER root

# Que Superset cargue nuestro pythonpath y crear carpetas necesarias
ENV PYTHONPATH="/app/pythonpath:${PYTHONPATH}"
RUN mkdir -p /app/pythonpath /app/superset/static/assets

# Instalar PyMySQL
RUN pip install --no-cache-dir PyMySQL

# Instalar dependencias extra (sin mysqlclient)
RUN pip install --no-cache-dir \
      psycopg2-binary \
      redis \
      celery \
      weasyprint

# Configuración
COPY superset_config.py /app/pythonpath/superset_config.py

# Imagen para el fondo
COPY assets/quantum-bg.png /app/superset/static/assets/quantum-bg.png
RUN chmod 0644 /app/superset/static/assets/quantum-bg.png

USER superset

# Script de arranque
COPY start.sh /start.sh

EXPOSE 8088
CMD ["sh", "/start.sh"]
