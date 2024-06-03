""" Built-in modules """
from typing import Any, Dict, Optional

""" Local modules """
from utils import Validator
from logs import CustomLogger
from errors import StatusNotFoundException
from database.local_db import RedisSession
from database.local_db.models.status.status import Status  # Import the Status model


logger = CustomLogger('UpdateStatus')

class UpdateStatus:
    def __init__(self, status_uid: int, state: Optional[str] = None, state_message: Optional[str] = None, state_details: Optional[Dict[str, Any]] = None, progress: Optional[Dict[str, Any]] = None) -> None:
        """
        Initialize the UpdateStatus instance with input values.

        Args:
            status_uid (int): The status ID.
            state (str, optional): The state of the status. Defaults to None.
            state_message (str, optional): The state message of the status. Defaults to None.
            state_details (Dict[str, Any], optional): The state details of the status. Defaults to None.
            progress (Dict[str, Any], optional): The progress of the status. Defaults to None.

        Raises:
            ValidationException: If validation of input values fails.
        """
        self.status_uid = status_uid
        self.state = state
        self.state_message = state_message
        self.state_details = state_details
        self.progress = progress

        # Validate input values.
        self.validate_input()

        # Create a new RedisSession instance.
        self.session = RedisSession()
    
    def validate_input(self) -> None:
        Validator.validate_string(self.status_uid, name="status_uid")
        Validator.validate_string(self.state, name="state")
        Validator.validate_string(self.state_message, name="state_message")
        
    def update(self) -> None:
        """
        Update the specified status in the DF_STATUS table.

        Args:
            None

        Returns:
            None
            
        Raises:
            ValidationException: If validation of the status ID fails.
        """
        try:
            data: dict = self.session.get(self.status_uid)
            status = Status.from_map(data)
            
            if status:
                if self.state is not None:
                    Validator.validate_string(self.state, name="state")
                    status.state = self.state
                if self.state_message is not None:
                    Validator.validate_string(self.state_message, name="state_message")
                    status.state_message = self.state_message
                if self.state_details is not None:
                    Validator.validate_dict(self.state_details, name="state_details")
                    status.state_details = self.state_details
                if self.progress is not None:
                    status.progress = self.progress
                    
                self.session.update(
                    key=status.uid,
                    data=status.to_map()
                )
                self.session.commit()
            else:
                raise StatusNotFoundException(f"Status with ID {self.status_uid} not found")

            # Close the session.
            self.close_session()
        except Exception as e:
            self.close_session()
            logger.error(f"Error updating status: {e}")
            raise e
    
    def close_session(self) -> None:
        """
        Close the SQLAlchemy session.

        Args:
            None

        Returns:
            None
        """
        self.session.close()
