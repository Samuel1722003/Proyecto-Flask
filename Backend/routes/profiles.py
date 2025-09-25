from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from db import get_connection

profile_bp = Blueprint("profiles", __name__)

@profile_bp.route("/create", methods=["POST"])
@jwt_required()
def create_profile():
    user_id = int(get_jwt_identity())
    data = request.json

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    try:
        # 1. Insertar perfil
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

        # 2. Insertar objetivos
        for obj in data.get("objectives", []):
            cursor.execute("""
                INSERT INTO profile_objectives (profile_id, objective_type, description)
                VALUES (%s, %s, %s)
            """, (profile_id, obj["type"], obj["description"][:500]))

        # 3. Insertar keywords
        for kw in data.get("keywords", []):
            cursor.execute("""
                INSERT INTO profile_keywords (profile_id, keyword)
                VALUES (%s, %s)
            """, (profile_id, kw.strip()))

        # 4. Insertar criterios
        for cr in data.get("criteria", []):
            cursor.execute("""
                INSERT INTO profile_criteria (profile_id, description)
                VALUES (%s, %s)
            """, (profile_id, cr))

        conn.commit()

        # 5. Traer perfil recién creado
        cursor.execute("SELECT * FROM profiles WHERE profile_id = %s", (profile_id,))
        profile = cursor.fetchone()

        # 6. Traer objetivos
        cursor.execute("SELECT * FROM profile_objectives WHERE profile_id = %s", (profile_id,))
        objectives = cursor.fetchall()

        # 7. Traer keywords
        cursor.execute("SELECT * FROM profile_keywords WHERE profile_id = %s", (profile_id,))
        keywords = [row["keyword"] for row in cursor.fetchall()]

        # 8. Traer criterios
        cursor.execute("SELECT * FROM profile_criteria WHERE profile_id = %s", (profile_id,))
        criteria = [row["description"] for row in cursor.fetchall()]

        # 9. Armar respuesta final
        response = {
            "profile": {
                **profile,
                "objectives": objectives,
                "keywords": keywords,
                "criteria": criteria
            }
        }

        return jsonify(response), 201

    except Exception as e:
        conn.rollback()
        print(f"❌ Error al crear perfil: {e}")
        return jsonify({"msg": "Error al crear perfil", "error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()