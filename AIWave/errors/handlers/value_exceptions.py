""" Local modules """
from errors.handlers.wave_exception import WaveException

class RequiredValueException(WaveException):
    """Raised when the input value is required"""

    def __init__(self, message="The input value is required", code="required_value"):
        self.message = message
        self.code = code
        super().__init__(self.message, self.code)

class MabyeWrongInputException(WaveException):
    """Raised when the input value may be wrong"""

    def __init__(self, message="This error may be happen when the user's input is not in the expected format or language", code="maybe_wrong_input"):
        self.message = message
        self.code = code
        super().__init__(self.message, self.code)

class InvalidValueException(WaveException):
    """Raised when the input value is not the correct value"""

    def __init__(self, message="The input value is not the correct value", code="invalid_value"):
        self.message = message
        self.code = code
        super().__init__(self.message, self.code)

class ValueTooSmallException(InvalidValueException):
    """Raised when the input value is too small"""

    def __init__(self, message="The input value is too small", code="value_too_small"):
        self.message = message
        self.code = code
        super().__init__(self.message, self.code)

class ValueTooLargeException(InvalidValueException):
    """Raised when the input value is too large"""

    def __init__(self, message="The input value is too large", code="value_too_large"):
        self.message = message
        self.code = code
        super().__init__(self.message, self.code)

class InvalidCharacterException(InvalidValueException):
    """Raised when the input value contains invalid characters"""

    def __init__(self, message="The input value contains invalid characters", code="invalid_characters"):
        self.message = message
        self.code = code
        super().__init__(self.message, self.code)

class InvalidLengthException(InvalidValueException):
    """Raised when the input value is not the correct length"""

    def __init__(self, message="The input value is not the correct length", code="invalid_length"):
        self.message = message
        self.code = code
        super().__init__(self.message, self.code)

class InvalidTypeException(InvalidValueException):
    """Raised when the input value is not the correct type"""

    def __init__(self, message="The input value is not the correct type", code="invalid_type"):
        self.message = message
        self.code = code
        super().__init__(self.message, self.code)
        
class InvalidFormatException(InvalidValueException):
    """Raised when the input value is not the correct format"""

    def __init__(self, message="The input value is not the correct format", code="invalid_format"):
        self.message = message
        self.code = code
        super().__init__(self.message, self.code)


class InvalidOptionException(InvalidValueException):
    """Raised when the input value is not the correct option"""

    def __init__(self, message="The input value is not the correct option", code="invalid_option"):
        self.message = message
        self.code = code
        super().__init__(self.message, self.code)

class InvalidStateException(InvalidValueException):
    """Raised when the input value is not the correct state"""

    def __init__(self, message="The input value is not the correct state", code="invalid_state"):
        self.message = message
        self.code = code
        super().__init__(self.message, self.code)
