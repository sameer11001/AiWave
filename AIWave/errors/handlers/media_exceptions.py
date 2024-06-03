""" Local modules """
from errors.handlers.wave_exception import WaveException

class MediaException(WaveException):
    """Raised when the media has an error"""
    
    def __init__(self, message="The media has an error", code="media_error"):
        self.message = message
        self.code = code
        super().__init__(self.message, self.code)

class MediaNotFoundException(MediaException):
    """Raised when the media is not found"""

    def __init__(self, message="The media is not found", code="media_not_found"):
        self.message = message
        self.code = code
        super().__init__(self.message, self.code)
