FROM apache/superset:latest

# Exponemos el puerto que usará Superset
EXPOSE 8088

# Comando de inicio de Superset con Gunicorn
CMD ["gunicorn", \
     "-w", "4", \
     "-k", "gevent", \
     "--timeout", "120", \
     "-b", "0.0.0.0:8088", \
     "superset.app:create_app()"]
