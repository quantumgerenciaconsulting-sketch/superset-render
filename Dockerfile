FROM apache/superset:latest

# Instalamos solo PyMySQL (no mysqlclient, así evitamos compilar)
USER root
RUN pip install pymysql

# Volvemos al usuario superset
USER superset

# Copiamos el script de inicio
COPY start.sh /start.sh

# Exponemos el puerto
EXPOSE 8088

# Ejecutamos el script
CMD ["sh", "/start.sh"]
