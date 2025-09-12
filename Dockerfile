FROM apache/superset:latest

# Instalar el driver MySQL (PyMySQL) en el entorno de Superset
USER root
RUN pip install --no-cache-dir PyMySQL

# Regresar al usuario superset y copiar scripts de arranque
USER superset
COPY start.sh /start.sh
CMD ["sh", "/start.sh"]
