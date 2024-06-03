""" Built-in modules """
from datetime import datetime
from typing import Any, Dict, Optional

""" Local modules """
from utils import Validator
from logs import CustomLogger
from database.local_db import Session
from errors import WaveException, UserNotFoundException
from database.local_db.models.user.user import User  # Import the User model


logger = CustomLogger('UpdateUser')

class UpdateUser:
    def __init__(self, user_uid: str, username: Optional[str] = None, image_url:Optional[str] = None, age:Optional[int] = None, data: Optional[Dict[str, Any]]=None, role:Optional[str]= None) -> None:
        """
        Initialize the UserUpdater instance with input values.

        Args:
            user_id (int): The ID of the user to update.
            username (str, optional): New username for the user.
            image_url (str, optional): New image URL for the user.
            age (int, optional): New age for the user.
            role (str, optional): New role for the user.
            created_at (datetime, optional): New creation date for the user.
            updated_at (datetime, optional): New modification date for the user.

        Raises:
            ValidationException: If validation of input values fails.
        """
        self.user_uid = user_uid
        self.username = username
        self.image_url = image_url
        self.age = age
        self.role = role

        self.session = Session()
        
    def update(self) -> User:
        
        """
        Update the specified user in the DF_USER table.
        
        Args:
            .
        
        Returns:
            User: The updated user record.
        
        Raises:
            ValidationException: If validation of the user ID fails.
        """
        
        Validator.validate_uid(self.user_uid)
        try:
            user = self.session.get(User, self.user_uid)
            
            if user:
                if self.username is not None:
                    Validator.validate_string(self.username, non_empty=False)
                    user.username = self.username
                if self.image_url is not None:
                    Validator.validate_string(self.image_url, non_empty=False)
                    user.image_url = self.image_url
                if self.age is not None:
                    Validator.validate_int(self.age)
                    user.age = self.age
                if self.role is not None:
                    Validator.validate_string(self.role)
                    user.role = self.role

                # Update the modification date.
                user.updated_at = datetime.now()
                # Copy from the user.
                copy_user = user.copy()
                
                self.session.commit()
                self.close_session()
                logger.info(f"User with ID {self.user_uid} updated.")
                
                return copy_user
            else:
                user_id = self.user_uid
                raise UserNotFoundException(f"User with ID {user_id} not found.")
            
        except WaveException as ve:
            logger.error(f"Validation Error: {ve}. with code: {ve.code}")
            raise
        except Exception as e:
            logger.error(f"Error updating user: {e}")
            raise
        finally:
            self.close_session()
            
    def close_session(self):
        """
        Close the session associated with the updater.
        """
        self.session.close()
