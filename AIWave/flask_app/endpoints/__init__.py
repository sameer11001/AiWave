# import endpoints blueprints
from flask_app.endpoints.word_wave import word_wave_blueprint
from flask_app.endpoints.admin import admin_blueprint
from flask_app.endpoints.auth import auth_blueprint
from flask_app.endpoints.users import users_blueprint
from flask_app.endpoints.storage import storage_blueprint
from flask_app.endpoints.researcher_wave import researcher_wave_blueprint
from flask_app.endpoints.vision_wave import vision_wave_blueprint

# import endpoints routes
from flask_app.endpoints.word_wave.routes import *
from flask_app.endpoints.admin.routes import *
from flask_app.endpoints.auth.routes import *
from flask_app.endpoints.users.routes import *
from flask_app.endpoints.storage.routes import *
from flask_app.endpoints.researcher_wave.routes import *
from flask_app.endpoints.vision_wave.routes import *
