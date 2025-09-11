from flask import Blueprint, request
from db import get_connection
import hashlib

auth_bp = Blueprint("auth", __name__)

# Registro de usuario
@auth_bp.route("/register", methods=["POST"])
def register():
    data = request.get_json()
    email = data.get("email")
    password = data.get("password")
    
    # Encriptar contraseña
    hashed = hashlib.sha256(password.encode()).hexdigest()
    
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("INSERT INTO users (email, password) VALUES (%s, %s)", (email, hashed))
    conn.commit()
    cursor.close()
    conn.close()
    
    return {"msg": "Usuario registrado exitosamente"}, 201

# Login de usuario
@auth_bp.route("/login", methods=["POST"])
def login():
    data = request.json
    email = data.get("email")
    password = data.get("password")

    hashed = hashlib.sha256(password.encode()).hexdigest()

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM users WHERE email = %s AND password = %s", (email, hashed))
    user = cursor.fetchone()
    cursor.close()
    conn.close()

    if user:
        return {"msg": "Login exitoso", "user_id": user["id"]}
    else:
        return {"msg": "Credenciales incorrectas"}, 401