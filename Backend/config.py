import os

class Config:
    SECRET_KEY = os.environ.get("SECRET_KEY") or "mi_super_secreto"
    JWT_SECRET_KEY = os.environ.get("JWT_SECRET_KEY") or "mi_jwt_secreto"

    MYSQL_HOST = "mysql-ccspria.alwaysdata.net"
    MYSQL_USER = "ccspria"
    MYSQL_PASSWORD = "samuel1722003/"
    MYSQL_DATABASE = "ccspria_1"