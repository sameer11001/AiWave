""" Built-in modules """
import uuid
from datetime import datetime
from typing import Any, Dict, Optional

""" Local modules """
from utils import Validator
from logs import CustomLogger
from database.local_db import Session
from errors import WaveException
from utils.hash_password import hash_password
from database.local_db.models.user.user import User  # Import the User model


logger = CustomLogger('AddUser')

class AddUser:
    def __init__(self, email: str, password:str, uid: Optional[str] = None, username: Optional[str] = None, image_url:Optional[str] = None, age:Optional[int] = None, data: Optional[Dict[str, Any]]=None, role:Optional[str]= None):
        """
        Initialize the AddUser instance with input values.

        Args:
            email (str): The user's name.
            password (str): The user's password.
            uid (str | optional): The user's uid.
            username (str | optional): The user's name.
            image_url (str | optional): The user's image url.
            age (int | optional): The user's age.
            role (str | optional): The user's role.
            data (Dict[str, Any] | optional): The user's data.

        Raises:
            ValidationException: If validation of input values fails.
        """
        
        self.email = email
        self.password = password
        
        self.uid = uid
        self.username = username
        self.image_url = image_url
        self.age = age
        self.data = data
        self.role = role
        
        # Validate input values
        self.validate_input()

        # Create a new SQLAlchemy session
        self.session = Session()
        
    def validate_input(self):
        # Validate input values and raise ValidationException if validation fails.
        Validator.validate_email(self.email, exception_on_not_exist=True)
        # validate password
        Validator.validate_password(self.password)
        
        if self.uid is not None:
            Validator.validate_uid(self.uid)
        if self.username is not None:
            Validator.validate_string(self.username, name="username")
        if self.image_url is not None:
            Validator.validate_string(self.image_url, name="image_url", non_empty=False)
        if self.age is not None:
            Validator.validate_int(self.age, name="age")
        if self.role is not None:
            Validator.validate_role(self.role)
        if self.data is not None:
            Validator.validate_user_data(self.data)

    def insert_user(self):
        """
        Insert a new user record into the database.

        This method creates a new User instance with the provided input values
        and inserts it into the User table.

        Raises:
            ValidationException: If validation of input values fails.
        """
        try:
            uid = self.uid if self.uid else uuid.uuid4().hex
            user = User(
                uid         = uid,
                email       = self.email,
                username    = self.username,
                image_url   = self.image_url,
                password    = hash_password(self.password),
                age         = self.age,
                role        = self.role,
                data        = self.data,
                created_at  = datetime.now(),
            )
            self.session.add(user)
            self.session.commit()
            self.close_session()
            logger.info(f"New user inserted successfully.")
        except WaveException as ve:
            logger.error(f"Validation Error: {ve}")
            raise
        except Exception as e:
            logger.error(f"Error inserting user: {e}")
            raise
        finally:
            self.close_session()

    def close_session(self):
        """
        Close the session associated with the inserter.
        """
        self.session.close()
