import requests
import json

# Ajusta esta URL a tu backend real
BASE_URL = "http://127.0.0.1:5000/api"
LOGIN_URL = f"{BASE_URL}/auth/login"
PROFILE_URL = f"{BASE_URL}/profiles/create"
PROJECT_URL = f"{BASE_URL}/projects/create"

# Credenciales de prueba
payload = {
    "email": "admin@test.com",   # cámbialo por un usuario válido
    "password": "1234"           # cámbialo por la contraseña real
}

try:
    print(f"➡️ Enviando POST a {LOGIN_URL} con payload: {payload}")
    response = requests.post(LOGIN_URL, json=payload)

    print(f"Status Code: {response.status_code}")
    print(f"Raw Body: {response.text}")

    data = response.json()
    print("✅ JSON decodificado:")
    print(json.dumps(data, indent=2, ensure_ascii=False))

    # 1. Obtener token
    token = data.get("access_token") or data.get("token")
    if not token:
        print("❌ No se recibió token, no se puede continuar")
        exit()

    headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/json"}

    # 2. Crear perfil de prueba
    profile_data = {
        "name": "Perfil de prueba",
        "area_id": 1,
        "project_type_id": 1,
        "participant_type_id": 1,
        "financing_type_id": 1,
        "financing_amount": 5000,
        "audience_type_id": 1,
        "title": "Título de perfil de prueba",
        "wants_patent": 0,
        "notes": "Notas de prueba",
        "objectives": [
            {"type": "general", "description": "Objetivo general de prueba"},
            {"type": "especifico", "description": "Objetivo específico de prueba"}
        ],
        "keywords": ["python", "api", "test"],
        "criteria": ["criterio 1", "criterio 2"]
    }

    print(f"\n➡️ Enviando POST a {PROFILE_URL} con profile_data")
    profile_resp = requests.post(PROFILE_URL, headers=headers, json=profile_data)
    print(f"Status Code: {profile_resp.status_code}")
    print(f"Raw Body: {profile_resp.text}")

    profile_json = profile_resp.json()
    print("✅ Perfil creado:")
    print(json.dumps(profile_json, indent=2, ensure_ascii=False))

    profile_id = profile_json.get("profile", {}).get("profile_id")
    if not profile_id:
        print("❌ No se recibió profile_id, no se puede crear proyecto")
        exit()

    # 3. Crear proyecto de prueba
    project_data = {
        "title": "Proyecto de prueba",
        "summary": "Este es un proyecto de prueba creado desde test_api",
        "profile_id": profile_id,
        "status": "borrador"
    }

    print(f"\n➡️ Enviando POST a {PROJECT_URL} con project_data")
    project_resp = requests.post(PROJECT_URL, headers=headers, json=project_data)
    print(f"Status Code: {project_resp.status_code}")
    print(f"Raw Body: {project_resp.text}")

    project_json = project_resp.json()
    print("✅ Proyecto creado:")
    print(json.dumps(project_json, indent=2, ensure_ascii=False))

except Exception as e:
    print(f"❌ Error de conexión: {e}")