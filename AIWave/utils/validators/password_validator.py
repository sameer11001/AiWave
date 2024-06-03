""" Local modules """
from utils.validators._imports import *
from utils.validators.custom_validator import validate_requerd
from utils.validators.value_validator import validate_string


def validate_strong_password( password) -> Optional[str]:
    """
    Check if a password meets basic strength criteria.

    Args:
        password (str): Password to be checked.

    Returns:
        str | None: Error message if the password is not strong enough, None otherwise.
    """
    # Password must contain at least one lowercase letter.
    if not re.search(r'[a-z]', password):
        return 'Password must contain at least one lowercase letter.'

    # Password must contain at least one uppercase letter.
    if not re.search(r'[A-Z]', password):
        return 'Password must contain at least one uppercase letter.'

    # Password must contain at least one digit.
    if not re.search(r'[0-9]', password):
        return 'Password must contain at least one digit.'

    # Password must contain at least one special character (e.g., !@#$%^&*()).
    if not re.search(f'[{re.escape(string.punctuation)}]', password):
        return 'Password must contain at least one special character (e.g., !@#$%^&*()).'
    
    return None

def validate_password( password) -> None:
    """
    Validate that a given value is a valid password.

    Args:
        password (any): Value to be validated.

    Raises:
        ValidationException: If the value is not a valid password.
    """
    validate_requerd(password, 'password')
    
    validate_string(password)
    
    if len(password) < 8:
        print("Password must be at least 8 characters long")
        raise InvalidPasswordException("Password must be at least 8 characters long")
    if len(password) > 50:
        print("Password must be at most 50 characters long")
        raise InvalidPasswordException("Password must be at most 50 characters long")
    
    # check if the password is strong enough
    message = validate_strong_password(password)
    if message is not None:
        print(message)
        raise WeakPasswordException(message)
