# /app/pythonpath/superset_config.py será cargado automáticamente por Superset
import pymysql
# Si algo intenta importar MySQLdb, que use PyMySQL
pymysql.install_as_MySQLdb()
