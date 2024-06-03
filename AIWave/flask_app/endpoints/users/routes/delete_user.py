""" Local modules """
from logs import CustomLogger
from utils import WaveResponse as r
from database.local_db.models import DeleteUser
from flask_app.endpoints.users import users_blueprint
from errors import WaveException, UserNotFoundException, AdminException

logger = CustomLogger('users_routes [<user_uid>/delete]')

@users_blueprint.route('/<user_uid>/delete', methods=['DELETE'])
def delete_user(user_uid: str):
    """
    Delete a user from the database.
    """
    try:
        # Validate the request.
        # Validator.validate_user_request(request)
        
        # Delete the user.
        DeleteUser(user_uid=user_uid).delete()
        
        logger.info(f'Successfully deleted user with uid `{user_uid}`.')
        return r.success(message=f'User with uid `{user_uid}` deleted successfully.')
    except AdminException as e:
        logger.error(e, code=e.code)
        return r.error(error=f'Cannot delete admin user with uid `{user_uid}`.', code=e.code, status_code=403)
    except UserNotFoundException as e:
        logger.error(e, code=e.code)
        return r.error(error=f'User with uid `{user_uid}` not found.', code=e.code, status_code=404)
    except WaveException as e:
        logger.error(e, code=e.code)
        return r.error(message='Failed to validate the request.', error=e, code=e.code)
    except Exception as e:
        logger.error(e)
        return r.error(message='Failed to delete the user.', error=e, status_code=500)
        # TODO: Add abort(403) if the user is not an admin.
