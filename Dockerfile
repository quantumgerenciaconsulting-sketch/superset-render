FROM apache/superset:latest

USER root

# Activamos el venv y luego instalamos PyMySQL ahí
RUN /app/.venv/bin/pip install --upgrade pip && /app/.venv/bin/pip install PyMySQL

USER superset

COPY start.sh /start.sh

EXPOSE 8088

CMD ["sh", "/start.sh"]
