FROM apache/superset:latest

USER root
RUN pip install --no-cache-dir PyMySQL

USER superset
COPY start.sh /start.sh
CMD [\"sh\", \"/start.sh\"]
