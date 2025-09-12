FROM apache/superset:latest

# Usamos sh -lc para poder "source" el venv
SHELL ["/bin/sh","-lc"]

# Instalamos PyMySQL dentro del virtualenv que usa Superset
USER root
RUN . /app/.venv/bin/activate && pip install --no-cache-dir PyMySQL

# Volvemos al usuario por defecto de Superset
USER superset

# Tu script de arranque (el que ya tienes funcionando)
COPY start.sh /start.sh

EXPOSE 8088
CMD ["sh", "/start.sh"]
