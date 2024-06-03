""" Built-in modules """
import uuid
from datetime import datetime
from typing import List, Optional

""" Local modules """
from utils import Validator
from logs import CustomLogger
from database.local_db import Session
from errors.handlers import WaveException, NotFoundException
from database.local_db.models.ai_process.ai_process import AIProcess

logger = CustomLogger('AIProcessController')

class AIProcessController:
    def __init__(self) -> None:
        """
        Initialize the AIProcessController class.
        
        Args:
            None
        
        Returns:
            None
        """
        pass
    
    def create(self, media_uid: str, model_name: str, model_key: str, data: Optional[dict] = None, task: Optional[str] = None) -> AIProcess:
        """
        create() method is used to create a AIProcess.
        
        Args:
            media_uid (str): The media's id.
            model_name (str): The AIProcess's model name.
            model_key (str): The AIProcess's model key.
            data (dict | optional): The AIProcess's data.
            task (str | optional): The AIProcess's task.
        
        Returns:
            AIProcess: The created AIProcess.
        """
        try:
            Validator.is_media_exist(media_uid)
            
            if data is None or not isinstance(data, dict):
                raise WaveException(f"The `data` is invalid ({type(data)}).")
            
            # Ceate a SQLAlchemy session
            session = Session()
            uid:str = f'{model_key}-{uuid.uuid4().hex}'
            # Create a new AIProcess instance
            ai_process = AIProcess(
                uid         = uid,
                media_uid   = media_uid,
                model_name  = model_name,
                model_key   = model_key,
                data        = data,
                task        = task,
                created_at  = datetime.now(),
            )
            # Create a copy of the ai_process
            ai_process_copy = ai_process.copy()
            # Add the AIProcess to the session
            session.add(ai_process)
            # Commit the session
            session.commit()
            # Close the session
            session.close()
            # Return the AIProcess
            return ai_process_copy
        except WaveException as e:
            logger.error(e, code=e.code)
            raise e
        except Exception as e:
            logger.error(e)
            raise e
    
    def get(self, uid: str) -> AIProcess:
        """
        get() method is used to get a AIProcess.
        
        Args:
            uid (str): The AIProcess's id.
        
        Returns:
            AIProcess: The AIProcess.
        """
        try:
            # Validate the arguments
            Validator.validate_requerd(uid, "uid")
            
            # Ceate a SQLAlchemy session
            session = Session()
            # Get the AIProcess from the database
            ai_process: AIProcess = session.query(AIProcess).filter(AIProcess.uid == uid).first()
            
            if ai_process is None:
                raise NotFoundException(f"The AIProcess with uid `{uid}` is not found.")
            
            # Close the session
            session.close()
            # Return the AIProcess
            return ai_process
        except WaveException as e:
            logger.error(e, code=e.code)
            raise e
        except Exception as e:
            logger.error(e)
            raise e
    
    def get_by_model_key(self, model_key: str) -> List[AIProcess]:
        """
        get_by_model_key() method is used to get a AIProcess by model key.
        
        Args:
            user_uid (str): The user's id.
        
        Returns:
            List[AIProcess]: The AIProcess.
        """
        try:
            # Validate the arguments
            Validator.validate_requerd(model_key, "model_key")
            
            # Ceate a SQLAlchemy session
            session = Session()
            # Get the AIProcess from the database
            ai_process: List[AIProcess] = session.query(AIProcess).filter(AIProcess.model_key == model_key).all()
            
            # Close the session
            session.close()
            # Return the AIProcess
            return ai_process
        except WaveException as e:
            logger.error(e, code=e.code)
            raise e
        except Exception as e:
            logger.error(e)
            raise e
        
    
    def update(self, uid: str, data: dict) -> AIProcess:
        """
        update() method is used to update a AIProcess.
        
        Args:
            uid (str): The AIProcess's id.
            data (dict): The AIProcess's data.
        
        Returns:
            AIProcess: The updated AIProcess.
        """
        try:
            # Validate the arguments
            Validator.validate_requerd(uid, "uid")
            Validator.validate_requerd(data, "data")
            
            # Ceate a SQLAlchemy session
            session = Session()
            # Get the AIProcess from the database
            ai_process: AIProcess = session.query(AIProcess).filter(AIProcess.uid == uid).first()
            
            if ai_process is None:
                raise NotFoundException(f"The AIProcess with uid `{uid}` is not found.")
            
            # Update the AIProcess
            ai_process.data = data
            ai_process.updated_at = datetime.now()
            # Commit the session
            session.commit()
            # Close the session
            session.close()
            # Return the AIProcess
            return ai_process
        except WaveException as e:
            logger.error(e, code=e.code)
            raise e
        except Exception as e:
            logger.error(e)
            raise e
    
    def delete(self, uid: str) -> AIProcess:
        """
        delete() method is used to delete a AIProcess.
        
        Args:
            uid (str): The AIProcess's id.
        
        Returns:
            AIProcess: The deleted AIProcess.
        """
        try:
            # Validate the arguments
            Validator.validate_requerd(uid, "uid")
            
            # Ceate a SQLAlchemy session
            session = Session()
            # Get the AIProcess from the database
            ai_process: AIProcess = session.query(AIProcess).filter(AIProcess.uid == uid).first()
            
            if ai_process is None:
                raise NotFoundException(f"The AIProcess with uid `{uid}` is not found.")
            
            # Delete the AIProcess
            session.delete(ai_process)
            # Commit the session
            session.commit()
            # Close the session
            session.close()
            # Return the AIProcess
            return ai_process
        except WaveException as e:
            logger.error(e, code=e.code)
            raise e
        except Exception as e:
            logger.error(e)
            raise e
