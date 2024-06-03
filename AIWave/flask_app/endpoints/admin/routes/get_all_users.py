""" Third-party modules """
from flask import request
from flask_app.endpoints.admin import admin_blueprint

""" Local modules """
from utils import Validator
from logs import CustomLogger
from errors import WaveException
from utils import WaveResponse as r
from database.local_db.models import GetUserData


logger = CustomLogger('admin_routes [/users]')

@admin_blueprint.route('/users', methods=['GET'])
def get_all_users():
    """
    Get all users from the database.
    """
    try:
        # Validate the request.
        Validator.validate_admin_request(request)
        
        # Get all users.
        users = GetUserData().get_all_users()
        # Convert all users to map.
        users_map = [user.to_map() for user in users]
        
        # If there are no users, return custom response with status code 204.
        if len(users_map) == 0:
            return r.success(message='No users found.', data=users_map, status_code=204)
        
        logger.info('Successfully retrieved all users.')
        return r.success(message='Successfully retrieved all users.', data=users_map)
    except WaveException as e:
        logger.error(e)
        return r.error(message='Failed to retrieve all users.', error=e, code=e.code)
    except Exception as e:
        logger.error(e)
        return r.error(message='Failed to retrieve all users.', error=e)
        # TODO: Add abort(403) if the user is not an admin.
