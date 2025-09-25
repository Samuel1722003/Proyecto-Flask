from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from db import get_connection

project_bp = Blueprint("projects", __name__)

@project_bp.route("/create", methods=["POST"])
@jwt_required()
def create_project():
    user_id = get_jwt_identity()
    data = request.json

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    try:
        # 1. Insertar proyecto
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
        project_id = cursor.lastrowid

        # 2. Traer el proyecto recién creado
        cursor.execute("SELECT * FROM projects WHERE project_id = %s", (project_id,))
        project = cursor.fetchone()

        # 3. Traer el perfil asociado
        profile_id = project["profile_id"]
        cursor.execute("SELECT * FROM profiles WHERE profile_id = %s", (profile_id,))
        profile = cursor.fetchone()

        # 4. Traer objetivos
        cursor.execute("SELECT * FROM profile_objectives WHERE profile_id = %s", (profile_id,))
        objectives = cursor.fetchall()

        # 5. Traer keywords
        cursor.execute("SELECT * FROM profile_keywords WHERE profile_id = %s", (profile_id,))
        keywords = [row["keyword"] for row in cursor.fetchall()]

        # 6. Traer criterios
        cursor.execute("SELECT * FROM profile_criteria WHERE profile_id = %s", (profile_id,))
        criteria = [row["description"] for row in cursor.fetchall()]

        # 7. Armar respuesta final
        response = {
            "project": project,
            "profile": {
                **profile,
                "objectives": objectives,
                "keywords": keywords,
                "criteria": criteria
            }
        }

        return jsonify(response), 201

    finally:
        cursor.close()
        conn.close()