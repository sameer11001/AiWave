""" Built-in modules """
from typing import Any, Dict

""" Third-party modules """
from flask import request

""" Local modules """
from errors import WaveException
from utils import WaveResponse as r
from flask_app.endpoints.auth import auth_blueprint
from database.local_db.models import AddUser, GetUserData


from logs import CustomLogger

logger = CustomLogger('auth_routes [signup]')

@auth_blueprint.route('/signup', methods=['POST'])
def signup():
    """
    Sign up a user.
    """
    try:
        # Get the JSON data from the request
        data: Dict[str, Any] = request.get_json()

        emali = data.get('email')
        password = data.get('password')
        username = data.get('username')
        image_url = data.get('image_url')
        age = data.get('age')
        data = data.get('data')

        # Create a new AddUser instance
        add_user = AddUser(
            email=emali,
            password=password,
            username=username,
            image_url=image_url,
            age=age,
            data=data,
        )

        # Insert the user into the database
        add_user.insert_user()

        # Get the user's data from the database
        user = GetUserData().get_user_by_email_and_password(email=emali, password=password)

        logger.info('Successfully signed up user.')
        return r.success(
            message='Successfully signed up user.',
            user=user.to_map(),
        )
    except WaveException as e:
        logger.error(e)
        return r.error(message='Failed to sign up user.', error=e.message, code=e.code)
    except Exception as e:
        logger.error(e)
        return r.error(message='Failed to sign up user.', error=e)
