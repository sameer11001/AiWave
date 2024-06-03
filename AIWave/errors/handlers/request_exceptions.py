""" Local modules """
from errors.handlers.wave_exception import WaveException

class InvalidRequestException(WaveException):
    """Raised when the request is invalid"""

    def __init__(self, message="The request is invalid", code="invalid_request"):
        self.message = message
        self.code = code
        super().__init__(self.message, self.code)
        
class InvalidRequestHeaderException(InvalidRequestException):
    """Raised when the request header is invalid"""

    def __init__(self, message="The request header is invalid", code="invalid_request_header"):
        self.message = message
        self.code = code
        super().__init__(self.message, self.code)
