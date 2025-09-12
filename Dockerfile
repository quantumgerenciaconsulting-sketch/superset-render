FROM apache/superset:latest

# Cambiamos al usuario superset (no root) para que el paquete quede accesible
USER superset

# Instalamos PyMySQL en el entorno del usuario superset
RUN pip install --user PyMySQL

# Copiamos el script de inicio
COPY start.sh /start.sh

EXPOSE 8088

CMD ["sh", "/start.sh"]
