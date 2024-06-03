""" Local modules """
from errors.handlers.wave_exception import WaveException

class AdminException(WaveException):
    """Raised when the admin exception occurs"""

    def __init__(self, message="The user is not an admin", code="admin_exception"):
        self.message = message
        self.code = code
        super().__init__(self.message, self.code)

class UserNotAdminException(AdminException):
    """Raised when the user is not an admin"""

    def __init__(self, message="The user is not an admin", code="user_not_admin"):
        self.message = message
        self.code = code
        super().__init__(self.message, self.code)
