""" Local modules """
from errors.handlers.wave_exception import WaveException

class NotAllowedException(WaveException):
    """Raised when the user is not allowed to perform the action"""

    def __init__(self, message="The user is not allowed to perform the action", code="not_allowed_exception"):
        self.message = message
        self.code = code
        super().__init__(self.message, self.code)
