""" Local modules """
from utils.validators._imports import *

def validate_uid(uid) -> None:
    """
    Validate that a given uid is a non-empty string.

    Args:
        uid (any): Uid to be validated.

    Raises:
        ValidationException: If the value is not a non-empty string.
    """
    if not isinstance(uid, str):
        print("`uid` must be a string")
        raise WaveException("`uid` must be a string")
    
    if uid is None or len(uid) == 0 :
        print("`uid` must be a non-empty string")
        raise WaveException("`uid` must be a non-empty string")

 
def validate_string(value, name: Optional[str] = None, non_empty: Optional[bool] = True) -> None:
    
    """
    Validate that a given value is a non-empty string.

    Args:
        value (any): Value to be validated.
        name (str | optional): Name of the value to be validated.
        non_empty (bool | optional): Whether the string must be non-empty.

    Raises:
        ValidationException: If the value is not a non-empty string.
    """
    if not isinstance(value, str):
        if name:
            print(f"`{name}` must be a string not {type(value)}")
            raise WaveException(f"`{name}` must be a string not {type(value)}")
        else:
            print(f"Value must be a string not {type(value)}")
            raise WaveException(f"Value must be a string not {type(value)}")
    
    if value is None or (len(value) == 0 and non_empty):
        if name:
            print(f"{name} must be a non-empty string")
            raise WaveException(f"`{name}` must be a non-empty string")
        else:
            print("Value must be a non-empty string")
            raise WaveException("Value must be a non-empty string")

    
def validate_dict(value, name: Optional[str] = None) -> None:
    """
    Validate that a given value is a dictionary.

    Args:
        value (any): Value to be validated.
        name (str | optional): Name of the value to be validated.

    Raises:
        ValidationException: If the value is not a dictionary.
    """
    
    if not isinstance(value, dict):
        if name:
            print(f"{name} must be a dictionary")
            raise WaveException(f"`{name}` must be a dictionary")
        else:
            print("Value must be a dictionary")
            raise WaveException("Value must be a dictionary")


def validate_int(value, name: Optional[str] = None) -> None:
    """
    Validate that a given value is an integer.

    Args:
        value (any): Value to be validated.
        name (str | optional): Name of the value to be validated.

    Raises:
        ValidationException: If the value is not an integer.
    """
    
    if not isinstance(value, int):
        if name:
            print(f"{name} must be an integer")
            raise WaveException(f"`{name}` must be an integer")
        else:
            print("Value must be an integer")
            raise WaveException("Value must be an integer")
    
    if value <=0:
        if name:
            print(f"{name} must be a positive integer")
            raise WaveException(f"`{name}` must be a positive integer")
        else:
            print("Value must be a positive integer")
            raise WaveException("Value must be a positive integer")
    

def validate_datetime(value) -> None:
        """
        Validate that a given value is a datetime object.

        Args:
            value (any): Value to be validated.

        Raises:
            ValidationException: If the value is not a datetime object.
        """
        
        if value is not None and not isinstance(value, datetime):
            print("Value must be a datetime object")
            raise WaveException("Value must be a datetime object")
    