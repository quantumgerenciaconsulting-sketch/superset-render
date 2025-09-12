FROM apache/superset:latest

USER root

# Instalar PyMySQL globalmente
RUN pip install --no-cache-dir PyMySQL

USER superset

COPY start.sh /start.sh

EXPOSE 8088

CMD ["sh", "/start.sh"]
