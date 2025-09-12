FROM apache/superset:latest

# Necesitamos sh -lc para usar "source" (.) del venv
SHELL ["/bin/sh","-lc"]

USER root

# Asegura que /app/pythonpath esté en el path de Superset y Python lo vea
ENV PYTHONPATH="/app/pythonpath:${PYTHONPATH}"
RUN mkdir -p /app/pythonpath

# Instala PyMySQL **dentro** del virtualenv que usa Superset.
# Si la imagen trae 'uv', úsalo; si no, usa pip del venv.
RUN if command -v uv >/dev/null 2>&1; then \
      . /app/.venv/bin/activate && uv pip install PyMySQL; \
    else \
      /app/.venv/bin/pip install --no-cache-dir PyMySQL; \
    fi

# Carga una config que aliasée MySQLdb -> PyMySQL por si algo lo requiere
COPY superset_config.py /app/pythonpath/superset_config.py

USER superset

# Tu script de arranque
COPY start.sh /start.sh

EXPOSE 8088
CMD ["sh", "/start.sh"]
