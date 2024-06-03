""" Built-in modules """
from typing import Any, List, Optional

""" Local modules """
from logs import CustomLogger
from database.local_db import Session
from database.local_db.models.media.media import Media  # Import the Media model
from database.local_db.models.ai_process.ai_process import AIProcess  # Import the AIProcess model


logger = CustomLogger('GetMediaData')

class GetMediaData:
    def __init__(self):
        """
        Initialize the GetMediaData instance with input values.

        Args:
            None

        Raises:
            ValidationException: If validation of input values fails.
        """

        # Create a new SQLAlchemy session
        self.session = Session()
        
    def get_media_by_id(self, media_uid: Any) -> Optional[Media]:
        """
        Retrieve a media record by ID.

        Args:
            media_uid (Any): ID of the media to retrieve .

        Returns:
            Media: Retrieved media record or None if not found.
        """
        try:
            media = self.session.query(Media).filter_by(uid=media_uid).first()
            return media
        except Exception as e:
            logger.error(f"Error retrieving media: {e}")
            return None
        finally:
            self.close_session()
    
    def get_media_by_user_uid(self, user_uid: Any) -> Optional[List[Media]]:
        """
        Retrieve a media record by user ID.

        Args:
            user_uid (Any): ID of the user to retrieve media for.

        Returns:
            List[Media]: Retrieved media records or None if not found.
        """
        try:
            media = self.session.query(Media).filter_by(user_uid=user_uid).all()
            return media
        except Exception as e:
            logger.error(f"Error retrieving media: {e}")
            return None
        finally:
            self.close_session()
    
    def get_all_media(self) -> Optional[List[Media]]:
        """
        Retrieve all media records.

        Args:
            None

        Returns:
            List[Media]: Retrieved media records or None if not found.
        """
        try:
            media = self.session.query(Media).all()
            return media
        except Exception as e:
            logger.error(f"Error retrieving media: {e}")
            return None
        finally:
            self.close_session()
    
    def get_media_by_model_key(self, model_key: str) -> Optional[List[Media]]:
        """
        Retrieve a media record by model key.

        Args:
            model_key (str): Model key of the media to retrieve.

        Returns:
            List[Media]: Retrieved media records or None if not found.
        """
        try:
            # The model key is stored in the AIProcess table
            media = self.session.query(Media).join(AIProcess).filter(AIProcess.model_key==model_key).all()
            return media
        except Exception as e:
            logger.error(f"Error retrieving media: {e}")
            return None
        finally:
            self.close_session()
        
    def close_session(self) -> None:
        """
        Close the session.

        Args:
            None

        Returns:
            None
        """
        self.session.close()
