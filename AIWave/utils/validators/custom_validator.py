""" Local modules """
from utils.validators._imports import *
    
def validate_requerd(value, name: Optional[str] = None) -> None:
    """
    Validate that a given value is a required.

    Args:
        value (any): Value to be validated.
        name (str | optional): Name of the value to be validated.

    Raises:
        ValidationException: If the value is not a required.
    """
    if value is None and name is not None:
        print(f"{name} is required")
        raise WaveException(f"`{name}` is required")
    elif value is None:
        print("Value is required")
        raise WaveException("Value is required")