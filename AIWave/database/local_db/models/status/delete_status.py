""" Built-in modules """


""" Local modules """
from utils import Validator
from logs import CustomLogger
from database.local_db import RedisSession


logger = CustomLogger('DeleteStatus')

class DeleteStatus:
    def __init__(self, status_uid: str):
        """
        Initialize the DeleteStatus instance with input values.

        Args:
            status_uid (str): The status's id.

        Raises:
            ValidationException: If validation of input values fails.
        """
        
        self.status_uid = status_uid
        
        Validator.validate_string(self.status_uid, name="status_uid")

        # Create a new RedisSession instance.
        self.session = RedisSession()
    
    def delete(self) -> None:
        """
        Delete a status from the database.

        Args:
            None
            
        Returns:
            None
            
        Raises:
            Exception: If deleting the status fails.
        """
        try:
            self.session.delete(self.status_uid)
            self.session.commit()
            
            logger.info(f"Status with id: {self.status_uid} deleted successfully.")
            
            self.close_session()
        except Exception as e:
            self.close_session()
            logger.error(f"Failed to delete status with id: {self.status_uid}.")
            raise e
        
            
    def close_session(self) -> None:
        """
        Close the session.

        Args:
            None
            
        Returns:
            None
        """
        self.session.close()
