""" Built-in modules """

""" Third-party modules """
from flask import Flask

""" Local modules """
from enums import Environment # Import the Environment enum
from config import WaveConfig # Import the Environment enum and the configuration classes
from errors import init_errors_routes # Import the InvalidOptionException class
from database.local_db import create_tables  # Import the init_db function
from utils.hash_password import init_bcrypt # Import the init_bcrypt function
from flask_app.routes import init_app_route # Import the init_app function
from flask_app.endpoints import (
    storage_blueprint,
    word_wave_blueprint,
    admin_blueprint,
    auth_blueprint,
    users_blueprint,
    researcher_wave_blueprint,
    vision_wave_blueprint,
)


def create_app(env: Environment = Environment.DEVELOPMENT) -> Flask:
    """
    Create a Flask application with the specified environment configuration.

    Args:
        env (Environment): The environment to configure the application.
            Valid values are Environment.DEVELOPMENT, Environment.PRODUCTION, or Environment.TESTING.

    Returns:
        Flask: The configured Flask application.
    """
    app = Flask(__name__)

    # Load configuration settings based on the provided environment
    app.config.from_object(WaveConfig.instance)

    #? Configure the application
    # Initialize the app routes
    init_app_route(app)
    # Initialize the error routes
    init_errors_routes(app)
    # Initialize the database
    create_tables()
    # Initialize the bcrypt
    init_bcrypt(app)

    # Register the blueprints
    app.register_blueprint(
        auth_blueprint,
        url_prefix='/auth'
    )
    app.register_blueprint(
        storage_blueprint,
        url_prefix='/storage'
    )
    app.register_blueprint(
        admin_blueprint,
        url_prefix='/admin'
    )
    app.register_blueprint(
        users_blueprint,
        url_prefix='/users'
    )
    
    WAVE_AI_PREFIX:str = '/ai'
    app.register_blueprint(
        word_wave_blueprint,
        url_prefix=f'{WAVE_AI_PREFIX}/word_wave'
    )
    app.register_blueprint(
        researcher_wave_blueprint,
        url_prefix=f'{WAVE_AI_PREFIX}/researcher_wave'
    )
    app.register_blueprint(
        vision_wave_blueprint,
        url_prefix=f'{WAVE_AI_PREFIX}/vision_wave'
    )

    return app
