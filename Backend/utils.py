from flask_bcrypt import Bcrypt
from flask_jwt_extended import create_access_token
from datetime import timedelta

bcrypt = Bcrypt()

def hash_password(password: str) -> str:
    return bcrypt.generate_password_hash(password).decode("utf-8")

def check_password(password_hash: str, password: str) -> bool:
    return bcrypt.check_password_hash(password_hash, password)

def generate_token(identity: int) -> str:
    return create_access_token(identity=identity, expires_delta=timedelta(hours=12))