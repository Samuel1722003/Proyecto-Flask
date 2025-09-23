from flask import Flask
from flask_cors import CORS
from flask_jwt_extended import JWTManager
from config import Config
from routes.auth import auth_bp
from routes.profiles import profile_bp
from routes.projects import project_bp

app = Flask(__name__)
app.config.from_object(Config)

CORS(app)
JWTManager(app)

# Blueprints
app.register_blueprint(auth_bp, url_prefix="/api/auth")
app.register_blueprint(profile_bp, url_prefix="/api/profiles")
app.register_blueprint(project_bp, url_prefix="/api/projects")

if __name__ == "__main__":
    app.run(debug=True)