import mysql.connector as mysql
from mysql.connector import Error

def get_connection():
    try:
        connection = mysql.connect(
            host='mysql-ccspria.alwaysdata.net',
            user = 'ccspria',
            password = 'samuel1722003/',
            database = 'ccspria_1'
        )
        if connection.is_connected():
            print("Conexión exitosa a la base de datos")
        return connection
    except Error as e:
        print(f"Error connecting to database: {e}")
        return None