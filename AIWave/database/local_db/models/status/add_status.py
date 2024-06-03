""" Built-in modules """
import time
from typing import Any, Dict, Optional

""" Local modules """
from utils import Validator
from logs import CustomLogger
from database.local_db import r, RedisSession
from database.local_db.models.status.status import Status  # Import the Status model


logger = CustomLogger('AddStatus')

class AddStatus:
    def __init__(self, media_uid: str, model_name: str, state: Optional[str] = None, state_message: Optional[str] = None, state_details: Optional[Dict[str, Any]] = None, progress: Optional[Dict[str, Any]] = None) -> None:
        """
        Initialize the AddStatus instance with input values.

        Args:
            media_uid (str): The uid of the media.
            model_name (str): The model's name.
            state (str, optional): The state of the status. Defaults to None.
            state_message (str, optional): The state message of the status. Defaults to None.
            state_details (Dict[str, Any], optional): The state details of the status. Defaults to None.
            progress (Dict[str, Any], optional): The progress of the status. Defaults to None.

        Raises:
            ValidationException: If validation of input values fails.
        """
        self.media_uid = media_uid
        self.model_name = model_name
        self.state = state
        self.state_message = state_message
        self.state_details = state_details
        self.progress = progress
        
        # Validate input values.
        self.validate_input()

        # Create a new RedisSession instance.
        self.session = RedisSession()
    
    def validate_input(self) -> None:
        Validator.validate_string(self.media_uid, name="media_uid")
        Validator.validate_string(self.model_name, name="model_name")
        
    def add(self) -> Optional[Status]:
        """
        Add a new status to the database.

        Args:
            None

        Returns:
            status (Status): The status that was added.
            
        Raises:
            Exception: If adding the status fails.
        """
        try:
            # Create a new status instance.
            status = Status(
                media_uid       = self.media_uid,
                model_name      = self.model_name,
                state           = self.state,
                state_message   = self.state_message,
                state_details   = self.state_details,
                progress        = self.progress,
                timestamp       = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
            )
            
            # Add the status to the session.
            self.session.add(
                key = status.uid,
                data = status.to_map()
            )
            self.session.commit()
            
            logger.info(f'Status {status.uid} added successfully.')
            
            # Close the session.
            self.close_session()
            
            return status
        except Exception as e:
            self.close_session()
            logger.error(f'Failed to add status: {e}')
            raise e
            
    def close_session(self):
        """
         Close the session associated with the inserter.
        """
        self.session.close()
