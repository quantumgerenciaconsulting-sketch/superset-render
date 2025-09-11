FROM apache/superset:latest

EXPOSE 8088

CMD ["superset", "run", "-p", "8088", "--host", "0.0.0.0"]
