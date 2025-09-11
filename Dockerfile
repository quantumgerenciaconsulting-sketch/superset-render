FROM apache/superset:latest

# Copiamos nuestro script de inicio
COPY start.sh /start.sh

# Exponemos el puerto de Superset
EXPOSE 8088

# Ejecutamos el script de arranque
CMD ["sh", "/start.sh"]
