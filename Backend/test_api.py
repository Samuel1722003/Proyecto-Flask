import requests

BASE_URL = "http://127.0.0.1:5000/api"

def safe_print_response(name, response):
    try:
        print(f"{name}:", response.status_code, response.json())
    except Exception:
        print(f"{name}:", response.status_code, response.text)

# 1. Registrar usuario
def test_register():
    url = f"{BASE_URL}/auth/register"
    data = {
        "email": "admin@test.com",
        "password": "1234",
        "name": "Admin",
        "phone": "10987654321",
    }
    response = requests.post(url, json=data)
    print("Registro:", response.status_code, response.json())

# 2. Iniciar sesión y obtener token
def test_login():
    url = f"{BASE_URL}/auth/login"
    data = {
        "email": "admin@test.com",
        "password": "1234"
    }
    response = requests.post(url, json=data)
    print("Login:", response.status_code, response.json())
    if response.status_code == 200:
        return response.json()["token"]
    return None

# 3. Insertar perfil con token
def test_create_profile(token):
    url = f"{BASE_URL}/profiles/"
    headers = {"Authorization": f"Bearer {token}"}
    data = {
        "name": "Proyecto de Energía Solar",
        "area_id": 1,
        "project_type_id": 2,
        "participant_type_id": 1,
        "financing_type_id": 5,
        "financing_amount": 0,
        "audience_type_id": 1,
        "title": "Mi Proyecto",
        "wants_patent": 0,
        "notes": "Proyecto de prueba con script Python",
        "objectives": [{"type": "general", "description": "Lograr un resultado"}],
        "keywords": ["IA", "Machine Learning"],
        "criteria": ["Evaluación por expertos"]
    }
    response = requests.post(url, json=data, headers=headers)
    safe_print_response("Crear perfil", response)

if __name__ == "__main__":
    test_register()
    token = test_login()
    if token:
        test_create_profile(token)
