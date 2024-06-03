""" Local modules """
from errors.handlers.wave_exception import WaveException

class InvalidEmailException(WaveException):
    """Raised when the input value is not the correct email"""

    def __init__(self, message="The input value is not the correct email", code="invalid_email"):
        self.message = message
        self.code = code
        super().__init__(self.message, self.code)


class EmailAlreadyExistsException(InvalidEmailException):
    """Raised when the email already exists"""

    def __init__(self, message="The email already exists", code="email_already_exists"):
        self.message = message
        self.code = code
        super().__init__(self.message, self.code)
