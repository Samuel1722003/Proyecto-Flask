from flask import Blueprint, request, jsonify
from db import get_connection
from utils import hash_password, check_password, generate_token

auth_bp = Blueprint("auth", __name__)

@auth_bp.route("/register", methods=["POST"])
def register():
    data = request.json
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("SELECT * FROM users WHERE email=%s", (data["email"],))
        if cursor.fetchone():
            return jsonify({"msg": "Email ya registrado"}), 400

        hashed = hash_password(data["password"])

        cursor.execute("""
            INSERT INTO users (email, password_hash, name, phone)
            VALUES (%s, %s, %s, %s)
        """, (data["email"], hashed, data["name"], data.get("phone")))

        conn.commit()
        return jsonify({"msg": "Usuario registrado"}), 201
    finally:
        cursor.close()
        conn.close()


@auth_bp.route("/login", methods=["POST"])
def login():
    data = request.json
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("SELECT * FROM users WHERE email=%s", (data["email"],))
        user = cursor.fetchone()

        if not user or not check_password(user["password_hash"], data["password"]):
            return jsonify({"msg": "Credenciales inválidas"}), 401

        token = generate_token(identity=str(user["user_id"]))
        return jsonify({"token": token, "user_id": user["user_id"]})
    finally:
        cursor.close()
        conn.close()