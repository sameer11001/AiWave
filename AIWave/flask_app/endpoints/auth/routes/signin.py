""" Built-in modules """
from typing import Any, Dict

""" Third-party modules """
from flask import request

""" Local modules """
from errors import WaveException
from utils import WaveResponse as r
from database.local_db.models import GetUserData
from flask_app.endpoints.auth import auth_blueprint


from logs import CustomLogger

logger = CustomLogger('auth_routes [signin]')

@auth_blueprint.route('/signin', methods=['POST'])
def signin():
    """
    Sign in a user.
    """
    try:
        # Get the JSON data from the request
        data: Dict[str, Any] = request.get_json()

        emali = data.get('email')
        password = data.get('password')

        # Get the user's data from the database
        user = GetUserData().get_user_by_email_and_password(email=emali, password=password)

        logger.info('Successfully signed in user.')
        return r.success(
            message='Successfully signed in user.',
            user=user.to_map(),
        )
    except WaveException as e:
        logger.error(e)
        return r.error(message='Failed to sign in user.', error=e.message, code=e.code)
    except Exception as e:
        logger.error(e)
        return r.error(message='Failed to sign in user.', error=e)
