FROM apache/superset:latest

USER root

# Actualizamos pip y agregamos PyMySQL globalmente
RUN pip install --upgrade pip && pip install pymysql

USER superset

COPY start.sh /start.sh

EXPOSE 8088

CMD ["sh", "/start.sh"]
