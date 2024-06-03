""" Local modules """
from errors.handlers.wave_exception import WaveException

class StatusNotFoundException(WaveException):
    """Raised when the status is not found"""

    def __init__(self, message="The status is not found", code="status_not_found"):
        self.message = message
        self.code = code
        super().__init__(self.message, self.code)
