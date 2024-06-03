""" Local modules """
from utils.validators._imports import *
from enums import Role


def validate_user_request(request) -> Any:
    """
    Validate that a given request contains valid user data.
    
    Args:
        request (any): Request to be validated.
        
    Returns:
        User: User object of the user who sent the request if the request is valid.
    
    Raises:
        ValidationException: If the request does not contain valid user data.
    """
    
    # Get the user ID from the "x-user-id" header
    user_uid = request.headers.get('x-user-id')

    # check if user_id is not None
    if user_uid is None:
        raise InvalidRequestHeaderException('No `x-user-id` included in the request header.')
    
    from database.local_db.models import GetUserData
    user = GetUserData().get_user_by_uid(user_uid)
    
    if not user:
        raise InvalidRequestHeaderException('The `x-user-id` included in the request header is not valid.')
    
    return user

def validate_admin_request(request) -> Any:
    """
    Validate that a given user is an admin.

    Args:
        user_uid (any): Value to be validated.
        
    Returns:
        User: User object of the user who sent the request if the request is valid.

    Raises:
        ValidationException: If the user is not an admin.
    """
    user = validate_user_request(request)
    if user is None or user.role != Role.ADMIN.value:
        print("User must be an admin")
        raise UserNotAdminException("User must be an admin")
    
    return user
