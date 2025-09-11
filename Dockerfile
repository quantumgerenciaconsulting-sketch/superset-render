FROM apache/superset:latest

# Copiamos nuestro script de inicio
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Exponemos el puerto de Superset
EXPOSE 8088

# Usamos el script como comando de arranque
CMD ["/start.sh"]
