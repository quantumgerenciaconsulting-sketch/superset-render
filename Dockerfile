FROM apache/superset:latest
SHELL ["/bin/sh","-lc"]
USER root

ENV PYTHONPATH="/app/pythonpath:${PYTHONPATH}"
RUN mkdir -p /app/pythonpath /app/superset/static/assets

# Driver MySQL en el venv
RUN if command -v uv >/dev/null 2>&1; then \
      . /app/.venv/bin/activate && uv pip install PyMySQL; \
    else \
      /app/.venv/bin/pip install --no-cache-dir PyMySQL; \
    fi

# Config (MySQLdb -> PyMySQL)
COPY superset_config.py /app/pythonpath/superset_config.py

# >>> NUEVO: descarga el logo durante el build
RUN python - <<'PY'\n\
import os, urllib.request\n\
os.makedirs('/app/superset/static/assets', exist_ok=True)\n\
urllib.request.urlretrieve(\n\
  'https://quantumpos.com.co/assets/logo-quantum-pos.png',\n\
  '/app/superset/static/assets/quantum-bg.png'\n\
)\n\
PY

USER superset
COPY start.sh /start.sh
EXPOSE 8088
CMD ["sh", "/start.sh"]
