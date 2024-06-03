""" Built-in modules """
from typing import List

""" Local modules """
from utils import Validator
from logs import CustomLogger
from database.local_db import Session
from database.local_db.models.media.media import Media  # Import the Media model

logger = CustomLogger('AddMedia')

class AddMedia:
    def __init__(self, user_uid: str):
        """
        Initialize the AddMedia instance with input values.

        Args:
            user_uid (str): The user's id.

        Raises:
            ValidationException: If validation of input values fails.
        """
        
        self.user_uid = user_uid
        
        Validator.is_user_exist(self.user_uid)

        # Create a new SQLAlchemy session
        self.session = Session()
        
    def validate_input(self, media: Media) -> None:
        """
        Validate input values and raise ValidationException if validation fails.
        
        Args:
            media (Media): The media to validate.
            
        Returns:
            None
            
        Raises:
            ValidationException: If validation of input values fails.
        """
        Validator.validate_string(media.file_name, name="file_name")
        Validator.validate_string(media.file_type, name="file_type")
        Validator.validate_string(media.file_path, name="file_path")
        Validator.validate_string(media.file_url, name="file_url")
        if media.data is not None:
            Validator.validate_user_data(media.data, name="data")
            
        
    def add(self, media: Media) -> None:
        """
        Add a new media to the database.

        Args:
            media (Media): The media to add.
            
        Returns:
            None
        
        Raises:
            Exception: If failed to validate input values or add the media.
        """
        # Validate input values
        self.validate_input(media)
        
        try:
            # Add the media to the database
            self.session.add(media)
            self.session.commit()
            
            logger.info(f'Media {media.uid} added successfully.')
            
        except Exception as e:
            logger.error(f'Failed to add media. Error: {e}')
            raise e
        finally:
            self.session.close()
    
    def add_all(self, medias: List[Media])-> list:
        """
        Add a list of medias to the database.

        Args:
            medias (List[Media]): The list of medias to add.

        Returns:
            list: The list of added medias.
            
        Raises:
            Exception: If failed to validate input values or add the medias.
        """
        
        # validate input values
        for media in medias:
            self.validate_input(media)
        
        try:
            # Add the medias to the database
            self.session.add_all(medias)
            self.session.commit()
            
            logger.info(f'{len(medias)} medias added successfully.')
            
            return medias
        except Exception as e:
            logger.error(f'Failed to add medias. Error: {e}')
            raise e
        finally:
            self.close_session()
    
    def close_session(self):
        """
         Close the session associated with the inserter.
        """
        self.session.close()
