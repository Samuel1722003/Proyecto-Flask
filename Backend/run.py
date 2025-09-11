from flask import Flask
from routes.auth import auth_bp
from routes.profiles import profiles_bp

app = Flask(__name__)

# Configuración básica
app.config['SECRET_KEY'] = 'supersecreto'

# Registrar blueprints (rutas separadas)
app.register_blueprint(auth_bp, url_prefix="/auth")
app.register_blueprint(profiles_bp, url_prefix="/profiles")

@app.route("/")

def index():
     return {"message": "La api esta funcionando correctamente"}
 
if __name__ == "__main__":
    app.run(debug=True)