""" Local modules """
from errors.handlers.wave_exception import WaveException

class UserException(WaveException):
    """Base class for other exceptions"""

    def __init__(self, message="User Exception", code="user_exception"):
        self.message = message
        self.code = code
        super().__init__(self.message, self.code)

class UserNotFoundException(UserException):
    """Raised when the user is not found"""

    def __init__(self, message="The user is not found", code="user_not_found"):
        self.message = message
        self.code = code
        super().__init__(self.message, self.code)

class InvalidEmailOrPasswordException(UserException):
    """Raised when the user's email or password is invalid"""

    def __init__(self, message="The user's email or password is invalid", code="invalid_email_or_password"):
        self.message = message
        self.code = code
        super().__init__(self.message, self.code)
