FROM apache/superset:latest

# Instalamos solo PyMySQL (driver 100% Python, no requiere compilación)
USER root
RUN pip install pymysql

# Volvemos al usuario superset
USER superset

# Copiamos el script de inicio
COPY start.sh /start.sh

EXPOSE 8088

CMD ["sh", "/start.sh"]
