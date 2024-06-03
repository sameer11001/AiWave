""" Local modules """
from utils.validators._imports import *
from enums import Role

def validate_role(value) -> None:
    """
    Validate that a given value is a valid role.

    Args:
        value (any): Value to be validated.

    Raises:
        ValidationException: If the value is not a valid role.
    """
    
    if value is not None and value not in [Role.ADMIN.value, Role.USER.value]:
        print("Value must be a valid role")
        raise WaveException("Value must be a valid role")


def validate_user_data(value) -> None:
    """
    Validate that a given value is a valid user data.

    Args:
        value (any): Value to be validated.

    Raises:
        ValidationException: If the value is not a valid user data.
    """
    
    if value is not None and not isinstance(value, dict):
        print("Value must be a valid user data")
        raise WaveException("Value must be a valid user data")
