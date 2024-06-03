""" Built-in modules """
from typing import Any, Optional

""" Local modules """
from logs import CustomLogger
from database.local_db import RedisSession
from database.local_db.models.status.status import Status  # Import the Status model


logger = CustomLogger('GetStatusData')

class GetStatusData:
    def __init__(self):
        """
        Initialize the GetStatusData instance with input values.

        Args:
            None

        Raises:
            ValidationException: If validation of input values fails.
        """

        # Create a new RedisSession instance.
        self.session = RedisSession()
        
    def get_status_by_id(self, status_uid: Any) -> Optional[Status]:
        """
        Retrieve a status record by ID.

        Args:
            status_uid (Any): ID of the status to retrieve .

        Returns:
            Status: Retrieved status record or None if not found.
        """
        try:
            data: dict = self.session.get(status_uid)
            status = Status.from_map(data)
            
            # Close the session.
            self.close_session()
            
            return status
        except Exception as e:
            self.close_session()
            logger.error(f"Error retrieving status: {e}")
            return None
       
    def close_session(self) -> None:
        """
        Close the session.

        Args:
            None

        Returns:
            None
        """
        self.session.close()
