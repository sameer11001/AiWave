""" Local modules """
from enums import Role
from utils import Validator
from logs import CustomLogger
from database.local_db import Session
from database.local_db.models.user.user import User  # Import the User model
from errors import (
    WaveException,
    UserNotFoundException,
    AdminException,
)


logger = CustomLogger('DeleteUser')

class DeleteUser:
    """
    Delete a user record from the DF_USER table.
    """
    
    def __init__(self, user_uid: str) -> None:
        """
        Initialize the DeleteUser instance with the user ID.
        
        Args:
            user_id (int): The user ID.
        
        Returns:
            None
        """
        self.user_uid = user_uid
        self.session = Session()


    def delete(self) -> None:
        """
        Delete a user type from the DF_USER table.

        Args:
            .
        Raises:
            ValidationException: If validation of the user ID fails.
        """
        Validator.validate_uid(self.user_uid)
        try:
            user = self.session.get(User, self.user_uid)
            
            if user and user.role != Role.ADMIN.value:
                self.session.delete(user)
                self.session.commit()
                self.close_session()
                user_id = self.user_uid
                logger.info(f"User with ID {user_id} deleted.")
            elif user and user.role == Role.ADMIN.value:
                user_id = self.user_uid
                raise AdminException(f"Cannot delete admin user with ID {user_id}.")
            else:
                user_id = self.user_uid
                raise UserNotFoundException(f"User with ID {user_id} not found.")
        except WaveException as ve:
            logger.error(f"Validation Error: {ve}")
            raise
        except Exception as e:
            logger.error(f"Error deleting user type: {e}")
            raise
        finally:
            self.close_session()
            
    def close_session(self):
        """
        Close the database session.
        """
        self.session.close()
