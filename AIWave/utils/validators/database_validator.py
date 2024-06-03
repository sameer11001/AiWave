""" Local modules """
from utils.validators._imports import *
from utils.validators.custom_validator import validate_requerd
from utils.validators.value_validator import validate_string


def validate_email(email, exception_on_not_exist: Optional[bool] = False) -> bool:
    """
    Validate that a given value is a valid email address.

    Args:
        email (any): Value to be validated.
        exception_on_not_exist (bool | optional): Whether to raise an exception if the email not exists.

    Returns:
        bool: True if the email address already exists, False otherwise.

    Raises:
        ValidationException: If the value is not a valid email address.
    """
    
    validate_requerd(email, 'email')
    
    if email is not None and not re.match(r'^[^@]+@[^@]+\.[^@]+$', email):
        print("Value must be a valid email address")
        raise InvalidEmailException("Value must be a valid email address")
    
    _is_email_exist = is_email_exist(email)
    
    if _is_email_exist and exception_on_not_exist:
        print("Email already exist")
        raise EmailAlreadyExistsException("Email already exist")
    
    return _is_email_exist

def is_email_exist(email:str, exception_on_not_exist: Optional[bool] = True) -> bool:
    """
    Check if an email address already exists.

    Args:
        email (str): Email address to be checked.
        exception_on_not_exist (bool | optional): Whether to raise an exception if the email not exists.

    Returns:
        bool: True if the email address already exists, False otherwise.
    """
    from database.local_db.models import GetUserData
    is_email_exist = GetUserData().get_user_by_email(email)
    return is_email_exist is not None

def is_user_exist(uid, exception_on_not_exist: Optional[bool] = True) -> Any:
    """
    Validate that a given value is a valid uid.

    Args:
        uid (any): Value to be validated.
        exception_on_not_exist (bool | optional): Whether to raise an exception if the user uid not exists.

    Returns:
        user (User | optional): User object of the uid if the uid already exists, None otherwise.

    Raises:
        ValidationException: If the value is not a valid uid.
    """
    
    validate_requerd(uid, 'uid')
    
    from database.local_db.models import GetUserData
    user = GetUserData().get_user_by_uid(uid)
    
    if not user and exception_on_not_exist:
        print("User not found")
        raise UserNotFoundException("User not found")
    
    return user

def is_media_exist(media_uid, exception_on_not_exist: Optional[bool] = True) -> Any:
    """
    Validate that a given value is a valid media id.

    Args:
        media_uid (any): The media's uid.
        exception_on_not_exist (bool | optional): Whether to raise an exception if the media uid not exists.

    Returns:
        media (Media | optional): media object of the media if the media uid already exists, None otherwise.

    Raises:
        ValidationException: If the value is not a valid media id.
    """
    
    validate_string(media_uid, 'media_uid')
    
    from database.local_db.models import GetMediaData
    media = GetMediaData().get_media_by_id(media_uid)
    
    if not media and exception_on_not_exist:
        print("Media not found")
        raise MediaNotFoundException("Media not found")
    
    return media


def is_status_exist(status_uid, exception_on_not_exist: Optional[bool] = True) -> Any:
    """
    Validate that a given value is a valid status id.

    Args:
        status_uid (any): Value to be validated.
        exception_on_not_exist (bool | optional): Whether to raise an exception if the status uid not exists.

    Returns:
        status (Status | optional): status object of the status if the status uid already exists, None otherwise.

    Raises:
        ValidationException: If the value is not a valid status id.
    """
    
    validate_string(status_uid, 'status_uid')
    
    from database.local_db.models import GetStatusData
    status = GetStatusData().get_status_by_id(status_uid)
    
    if not status and exception_on_not_exist:
        print("Status not found")
        raise StatusNotFoundException("Status not found")
    
    return status


def validate_media_list(media_list, user) -> Any:
    """
    Validate that a given media list is valid for a given user.

    Args:
        media_list (list): List of media to be validated.
        user (User): User to be validated.

    Returns:
        media_list (list): List of media to be validated.

    Raises:
        ValidationException: If the media list is not valid for the user.
    """
    
    if media_list is None:
        print("Media not found")
        raise MediaNotFoundException("Media not found")
    
    if user.role == 'user':
        # Filter out media that are not owned by the user
        media_list = list(filter(lambda media: media.user_uid == user.uid, media_list))
    
    return media_list
