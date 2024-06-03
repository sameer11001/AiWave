""" Local modules """
from utils import Validator
from logs import CustomLogger
from database.local_db import Session
from database.local_db.models.ai_process.ai_process import AIProcess  # Import the Media model


logger = CustomLogger('DeleteMedia')

class DeleteMedia:
    def __init__(self, media_uid: int):
        """
        Initialize the DeleteMedia instance with input values.

        Args:
            media_id (int): The media's id.

        Raises:
            ValidationException: If validation of input values fails.
        """
        
        self.media_uid = media_uid
        
        self.__media = Validator.is_media_exist(self.media_uid)

        # Create a new SQLAlchemy session
        self.session = Session()
        
    def delete_dependent_records(self) -> None:
        """
        Delete dependent records in the DF_AIProcess table before deleting the media.
        """
        try:
            # Query and delete dependent records
            self.session.query(AIProcess).filter_by(media_uid=self.media_uid).delete()
            self.session.commit()
            logger.info(f"Dependent records for Media with id: {self.media_uid} deleted successfully.")
        except Exception as e:
            logger.error(f"Failed to delete dependent records for Media with id: {self.media_uid}.")
            raise e

    def delete(self) -> None:
        """
        Delete a media from the database.
        """
        try:
            # Delete dependent records first
            self.delete_dependent_records()

            # Delete the media from the database
            self.session.delete(self.__media)
            self.session.commit()

            logger.info(f"Media with id: {self.media_uid} deleted successfully.")
        except Exception as e:
            logger.error(f"Failed to delete media with id: {self.media_uid}.")
            raise e
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
