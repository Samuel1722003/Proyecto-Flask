import mysql.connector as mysql
from mysql.connector import Error

def get_connection():
    try:
        connection = mysql.connect(
            host='localhost',
            user = 'root',
            password = '1722003',
            database = 'proyecto'
        )
        return connection
    except Error as e:
        print(f"Error connecting to database: {e}")
        return None