import mysql.connector
from mysql.connector import Error

try:
    # Conexión
    connection = mysql.connector.connect(
        host="localhost",       # Cambia si usas otro servidor
        user="root",            # Tu usuario de MySQL
        password="1722003", # Tu contraseña de MySQL
        database="proyecto" # El nombre de la BD que creaste
    )

    if connection.is_connected():
        print("✅ Conexión exitosa a la base de datos")
        db_info = connection.get_server_info()
        print("Versión del servidor MySQL:", db_info)

        cursor = connection.cursor()
        cursor.execute("SELECT DATABASE();")
        record = cursor.fetchone()
        print("Usando base de datos:", record)

except Error as e:
    print("❌ Error al conectar a MySQL:", e)

finally:
    if 'connection' in locals() and connection.is_connected():
        cursor.close()
        connection.close()
        print("🔒 Conexión cerrada")