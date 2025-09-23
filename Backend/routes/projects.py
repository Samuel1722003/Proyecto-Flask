from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from db import get_connection

project_bp = Blueprint("projects", __name__)

@project_bp.route("/", methods=["POST"])
@jwt_required()
def create_project():
    user_id = get_jwt_identity()
    data = request.json

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("""
            INSERT INTO projects (user_id, profile_id, title, summary, status)
            VALUES (%s,%s,%s,%s,%s)
        """, (
            user_id,
            data.get("profile_id"),
            data["title"],
            data.get("summary"),
            data.get("status", "borrador")
        ))

        conn.commit()
        return jsonify({"msg": "Proyecto creado"}), 201
    finally:
        cursor.close()
        conn.close()