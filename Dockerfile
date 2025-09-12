FROM apache/superset:latest

USER root

# Instalar dependencias del sistema para MySQL
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    default-libmysqlclient-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Instalar conectores de Python para MySQL
RUN pip install --no-cache-dir \
    mysqlclient \
    PyMySQL \
    cryptography

USER superset

COPY start.sh /start.sh

EXPOSE 8088
CMD ["sh", "/start.sh"]
