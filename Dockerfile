FROM apache/superset:latest

# Instalamos el driver dentro de un path que Superset carga por defecto
USER root
ENV PYTHONPATH="/app/pythonpath:${PYTHONPATH}"
RUN mkdir -p /app/pythonpath \
 && pip install --no-cache-dir --target /app/pythonpath PyMySQL

# Volvemos al usuario normal de Superset
USER superset

# Script de arranque
COPY start.sh /start.sh

EXPOSE 8088
CMD ["sh","/start.sh"]


