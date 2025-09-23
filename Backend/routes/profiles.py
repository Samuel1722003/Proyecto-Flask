from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from db import get_connection

profile_bp = Blueprint("profiles", __name__)

@profile_bp.route("/", methods=["POST"])
@jwt_required()
def create_profile():
    user_id = int(get_jwt_identity())
    data = request.json

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    try:
        # Insertar perfil
        cursor.execute("""
            INSERT INTO profiles (
                user_id, name, area_id, project_type_id,
                participant_type_id, financing_type_id, financing_amount,
                audience_type_id, title, wants_patent, notes
            ) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
        """, (
            user_id,
            data["name"],
            data.get("area_id"),
            data.get("project_type_id"),
            data.get("participant_type_id"),
            data.get("financing_type_id"),
            data.get("financing_amount", 0),
            data.get("audience_type_id"),
            data.get("title"),
            data.get("wants_patent", 0),
            data.get("notes")
        ))
        profile_id = cursor.lastrowid

        # Objetivos
        for obj in data.get("objectives", []):
            cursor.execute("""
                INSERT INTO profile_objectives (profile_id, objective_type, description)
                VALUES (%s, %s, %s)
            """, (profile_id, obj["type"], obj["description"][:500]))

        # Keywords
        for kw in data.get("keywords", []):
            cursor.execute("""
                INSERT INTO profile_keywords (profile_id, keyword)
                VALUES (%s, %s)
            """, (profile_id, kw.strip()))

        # Criterios
        for cr in data.get("criteria", []):
            cursor.execute("""
                INSERT INTO profile_criteria (profile_id, description)
                VALUES (%s, %s)
            """, (profile_id, cr))

        conn.commit()
        return jsonify({"msg": "Perfil creado", "profile_id": profile_id}), 201
    
    except Exception as e:
        conn.rollback()
        return jsonify({"msg": "Error al crear perfil", "error": str(e)}), 500
    
    finally:
        cursor.close()
        conn.close()