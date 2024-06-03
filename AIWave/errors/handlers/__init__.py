# Desc: Error handlers for the application
from errors.handlers.wave_exception import WaveException

# Import all the error handlers
from errors.handlers.admin_exceptions import *
from errors.handlers.request_exceptions import *
from errors.handlers.password_exceptions import *
from errors.handlers.value_exceptions import *
from errors.handlers.user_exceptions import *
from errors.handlers.email_exceptions import *
from errors.handlers.status_exceptions import *
from errors.handlers.media_exceptions import *
from errors.handlers.permissions_exceptions import *
from errors.handlers.conversations_exceptions import *
from errors.handlers.embedding_exceptions import *
