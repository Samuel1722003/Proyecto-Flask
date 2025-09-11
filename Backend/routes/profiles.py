from flask import Blueprint, request
from db import get_connection

profiles_bp = Blueprint('profiles', __name__)

@profiles_bp.route("/", methods=["POST"])
def create_profile():
    data = request.json
    user_id = data.get("user_id")
    name = data.get("name")
    area_id = data.get("area_id")
    project_type_id = data.get("project_type_id")
    title = data.get("title")

    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("""
        INSERT INTO profiles (user_id, name, area_id, project_type_id, title)
        VALUES (%s, %s, %s, %s, %s)
    """, (user_id, name, area_id, project_type_id, title))
    conn.commit()
    cursor.close()
    conn.close()

    return {"msg": "Perfil creado exitosamente"}

@profiles_bp.route("/<int:user_id>", methods=["GET"])
def get_profiles(user_id):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM profiles WHERE user_id = %s", (user_id,))
    profiles = cursor.fetchall()
    cursor.close()
    conn.close()

    return {"profiles": profiles}