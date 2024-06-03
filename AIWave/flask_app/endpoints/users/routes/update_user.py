""" Built-in modules """
from typing import Any, Dict

""" Third-party modules """
from flask import request

""" Local modules """
from utils import Validator
from logs import CustomLogger
from utils import WaveResponse as r
from database.local_db.models import UpdateUser
from flask_app.endpoints.users import users_blueprint
from errors import WaveException, UserNotFoundException

logger = CustomLogger('users_routes [<user_uid>/update]')

@users_blueprint.route('/<user_uid>/update', methods=['PUT'])
def update_user(user_uid: str):
    """
    Update a user from the database.
    """
    try:
        # Validate the request.
        Validator.is_user_exist(user_uid)
        
        # Get the data from the request.
        data: Dict[str, Any] = request.get_json()
        
        username: str = data.get('username')
        age: int = data.get('age')
        image_url: str = data.get('image_url')
        data: Dict[str, Any] = data.get('data')
        
        if username is None and age is None and image_url is None and data is None:
            raise Exception("There is nothing to update.")
        
        # Delete the user.
        update_user = UpdateUser(
            user_uid    = user_uid,
            username    = username,
            age         = age,
            image_url   = image_url,
            data        = data
        )
        
        # Update the user.
        new_user = update_user.update()
        
        logger.info(f'Successfully updated user.')
        return r.success(message=f'User with uid `{user_uid}` updated successfully.', user=new_user.to_map())
    except UserNotFoundException as e:
        logger.error(e, code=e.code)
        return r.error(error=f'User with uid `{user_uid}` not found.', code=e.code, status_code=404)
    except WaveException as e:
        logger.error(e, code=e.code)
        return r.error(message='Failed to validate the request.', error=e, code=e.code)
    except Exception as e:
        logger.error(e)
        return r.error(message='Failed to update the user.', error=e)
