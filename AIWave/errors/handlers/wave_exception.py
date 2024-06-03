class WaveException(Exception):
    """Raised when a wave exception occurs"""
    
    def __init__(self, message="An error occurred", code="error"):
        self.message = message
        self.code = code
        super().__init__(self.message)
        

class NotFoundException(WaveException):
    """Raised when a not found error occurs"""
    
    def __init__(self, message="Not found", code="not_found"):
        self.message = message
        self.code = code
        super().__init__(self.message, self.code)
