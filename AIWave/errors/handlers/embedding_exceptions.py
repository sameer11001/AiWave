""" Local modules """
from errors.handlers.wave_exception import NotFoundException

class EmbeddingNotFoundException(NotFoundException):
    """Raised when the embedding is not found"""

    def __init__(self, message="The embedding is not found", code="embedding_not_found"):
        self.message = message
        self.code = code
        super().__init__(self.message, self.code)
