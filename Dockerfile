FROM apache/superset:latest

USER root

# Instalar dependencias de DB mediante "extras"
RUN pip install --upgrade pip \
    && pip install "apache-superset[mysql]"

USER superset

COPY start.sh /start.sh

EXPOSE 8088

CMD ["sh", "/start.sh"]
