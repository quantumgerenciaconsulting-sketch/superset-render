FROM apache/superset:latest

# Cambiamos a root para instalar paquetes
USER root

# Actualizamos pip e instalamos PyMySQL
RUN pip install --upgrade pip && pip install PyMySQL

# Volvemos al usuario superset
USER superset

# Copiamos el script de inicio
COPY start.sh /start.sh

# Exponemos el puerto
EXPOSE 8088

# Ejecutamos el script
CMD ["sh", "/start.sh"]
