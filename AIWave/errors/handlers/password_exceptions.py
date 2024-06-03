""" Local modules """
from errors.handlers.wave_exception import WaveException

class InvalidPasswordException(WaveException):
    """Raised when the input value is not the correct password"""

    def __init__(self, message="The input value is not the correct password", code="invalid_password"):
        self.message = message
        self.code = code
        super().__init__(self.message, self.code)

class WeakPasswordException(InvalidPasswordException):
    """Raised when the input value is not the correct password"""

    def __init__(self, message="The input value is not the correct password", code="weak_password"):
        self.message = message
        self.code = code
        super().__init__(self.message, self.code)
