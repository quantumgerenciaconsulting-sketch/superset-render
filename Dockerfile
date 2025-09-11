FROM apache/superset:latest

# Instalamos driver de MySQL (usaremos PyMySQL)
USER root
RUN pip install pymysql

# Volvemos al usuario superset
USER superset

# Copiamos el script de inicio
COPY start.sh /start.sh

# Exponemos el puerto de Superset
EXPOSE 8088

# Ejecutamos el script
CMD ["sh", "/start.sh"]
