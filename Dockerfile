FROM apache/superset:latest

USER root
ENV PYTHONPATH="/app/pythonpath:${PYTHONPATH}"
RUN mkdir -p /app/pythonpath \
 && pip install --no-cache-dir --target /app/pythonpath PyMySQL
USER superset

COPY start.sh /start.sh

EXPOSE 8088
CMD ["sh", "/start.sh"]
