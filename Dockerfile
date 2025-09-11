FROM apache/superset:latest

# Instalamos driver de MySQL
USER root
RUN pip install mysqlclient pymysql

# Volvemos al usuario superset
USER superset

# Copiamos el script de inicio
COPY start.sh /start.sh

# Exponemos el puerto
EXPOSE 8088

# Ejecutamos el script
CMD ["sh", "/start.sh"]
