""" Built-in modules """
from typing import Any, List, Optional

""" Local modules """
from utils import Validator
from logs import CustomLogger
from database.local_db import Session
from utils.hash_password import check_password
from database.local_db.models.user.user import User  # Import the User model
from errors import (
    WaveException,
    UserNotFoundException,
    InvalidEmailOrPasswordException,
)


logger = CustomLogger('GetUserData')

class GetUserData:
    
    def __init__(self) -> None:
        """
        Initialize the GetUserData instance.
        
        Args:
            .
        
        Returns:
            None
        """
        self.session = Session()

    def get_all_users(self) -> List[User]:
        """
        Retrieve all user records.

        Returns:
            list: List of user records.
        """
        try:
            users = self.session.query(User).all()
            return users
        except Exception as e:
            logger.error(f"Error retrieving users: {e}")
            return []
        finally:
            self.close_session()

    def get_user_by_uid(self, user_uid: Any) -> Optional[User]:
        """
        Retrieve a user record by ID.

        Args:
            user_uid (Any): ID of the user to retrieve .

        Returns:
            User: Retrieved user record or None if not found.
        """
        Validator.validate_uid(user_uid)
        try:
            user = self.session.query(User).get(user_uid)
            return user
        except Exception as e:
            logger.error(f"Error retrieving user: {e}")
            return None
        finally:
            self.close_session()
    
    def get_user_by_email(self, email: str) -> Optional[User]:
        """
        Retrieve a user record by email.

        Args:
            email (str): email of the user to retrieve.

        Returns:
            User: Retrieved user record or None if not found.
        """
        try:
            user = self.session.query(User).filter_by(email=email).first()
            return user
        except Exception as e:
            logger.error(f"Error retrieving user: {e}")
            return None
        finally:
            self.close_session()
        
    def get_user_by_email_and_password(self, email: str, password: str) -> Optional[User]:
        """
        Retrieve a user record by email and password.

        Args:
            email (str): email of the user to retrieve.
            password (str): password of the user to retrieve.

        Returns:
            User: Retrieved user record or None if not found.
        """
        is_email_exists = Validator.validate_email(email)
        Validator.validate_requerd(password, name="password")
        
        if not is_email_exists:
            raise UserNotFoundException("User not found.")
        
        try:
            user = self.get_user_by_email(email=email)
            if user is None or not check_password(password=password, hashed_password=user.password):
                raise InvalidEmailOrPasswordException()
            return user
        except WaveException as e:
            raise
        except Exception as e:
            logger.error(f"Error retrieving user: {e}")
            return None
        finally:
            self.close_session()

    def close_session(self):
        """
        Close the session associated with the retriever.
        """
        self.session.close()
