""" Local modules """
from errors.handlers.wave_exception import WaveException

class ConversationException(WaveException):
    """Base class for other exceptions"""

    def __init__(self, message="Conversation Exception", code="conversation_exception"):
        self.message = message
        self.code = code
        super().__init__(self.message, self.code)

class ConversationNotFoundException(ConversationException):
    """Raised when the conversation is not found"""

    def __init__(self, message="The conversation is not found", code="conversation_not_found"):
        self.message = message
        self.code = code
        super().__init__(self.message, self.code)
