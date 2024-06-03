""" Third-party modules """
from flask import Flask
from flask_bcrypt import Bcrypt

bcrypt = Bcrypt()

def init_bcrypt(app: Flask):
    """
    Initialize the database and create tables.

    Args:
        app (Flask): The Flask application instance.
    """
    with app.app_context():
        bcrypt.init_app(app)

# Function to hash a password
def hash_password(password):
    """
    Hash a password using Flask-Bcrypt.

    Args:
        password (str): The plaintext password to be hashed.

    Returns:
        str: The hashed password.
    """
    hashed_password = bcrypt.generate_password_hash(password).decode('utf-8')
    return hashed_password

# Function to check if a password matches a hashed password
def check_password(password, hashed_password):
    """
    Check if a password matches a hashed password.

    Args:
        password (str): The plaintext password to be checked.
        hashed_password (str): The hashed password to compare against.

    Returns:
        bool: True if the password matches the hashed password, False otherwise.
    """
    return bcrypt.check_password_hash(hashed_password, password)
