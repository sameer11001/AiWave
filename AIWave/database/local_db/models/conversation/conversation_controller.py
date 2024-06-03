""" Built-in modules """
import uuid
from typing import Optional
from datetime import datetime

""" Local modules """
from enums import Role
from utils import Validator
from logs import CustomLogger
from database.local_db import Session
from errors.handlers import WaveException, NotAllowedException
from database.local_db.models.user.user import User  # Import the User model
from database.local_db.models.conversation.conversation import Conversation  # Import the Conversation model


logger = CustomLogger('ConversationController')

class ConversationController:
    def __init__(self) -> None:
        """
        Initialize the ConversationController class.
        
        Args:
            None
        
        Returns:
            None
        """
        pass
    
    def create(self, user_uid: str, chat_memory: list, doc_files: list, prefix: Optional[str] = 'mb', model_name:Optional[str] = None) -> Conversation:
        """
        create() method is used to create a conversation.
        
        Args:
            user_uid (str): The user's id.
            chat_memory (list): The conversation's chat memory.
            doc_files (list): The conversation's doc files.
            prefix (str | optional): The conversation's prefix.
            model_name (str | optional): The conversation's model name.
        
        Returns:
            Conversation: The created conversation.
        """
        try:
            Validator.is_user_exist(user_uid)

            if chat_memory is None and doc_files is None:
                raise WaveException("The `chat_memory` and `doc_files` are None. At least one of them must be not None.")
            
            if chat_memory is not None and not isinstance(chat_memory, list):
                raise WaveException(f"The `chat_memory` is invalid ({type(chat_memory)}).")
            
            if doc_files is not None and not isinstance(doc_files, list):
                raise WaveException(f"The `doc_files` is invalid ({type(doc_files)}).")
        
            # Ceate a SQLAlchemy session
            session = Session()
            uid:str = f'{prefix}-{uuid.uuid4().hex}'
            # Create a new Conversation instance
            conversation = Conversation(
                uid         = uid,
                user_uid    = user_uid,
                model_name  = model_name,
                chat_memory = {'data': chat_memory},
                doc_files   = {'data': doc_files},
                created_at  = datetime.now(),
            )
            # Create a copy of the conversation
            conversation_copy = conversation.copy()
            # Add the conversation to the session
            session.add(conversation)
            # Commit the session
            session.commit()
            # Close the session
            session.close()
            return conversation_copy
        except WaveException as e:
            logger.error(e, code=e.code)
            raise
        except Exception as e:
            logger.error(f"An error occurred while creating a conversation: {e}")
            raise Exception("An error occurred while creating a conversation.") from e  
    
    def get(self, user_uid: str, conversation_uid: str) -> Conversation:
        """
        get() method is used to get a conversation by uid.
        
        Args:
            user_uid (str): The user's id.
            conversation_uid (str): The conversation's id.
        
        Returns:
            Conversation: The conversation.
        """
        
        try:
            # Validate the arguments
            Validator.validate_requerd(user_uid, "user_uid")
            Validator.validate_requerd(conversation_uid, "conversation_uid")
            # Validate the arguments' types
            Validator.validate_string(user_uid, "user_uid")
            Validator.validate_string(conversation_uid, "conversation_uid")
            
            # Check if the user exists
            user = Validator.is_user_exist(user_uid)
            
            # Create a SQLAlchemy session
            session = Session()
            # Get the conversation by uid
            conversation = session.query(Conversation).filter_by(uid=conversation_uid).first()
            
            if conversation is not None and (conversation.user_uid != user_uid and user.role != Role.ADMIN.value):
                raise NotAllowedException("You are not allowed to get this conversation.")
            
            # Close the session
            session.close()
            return conversation
        except WaveException as e:
            logger.error(e, code=e.code)
            raise
        except Exception as e:
            logger.error(f"An error occurred while getting a conversation by uid: {e}")
            raise Exception("An error occurred while getting a conversation by uid.") from e
    
    def update(self, conversation_uid: str, chat_memory: Optional[list] = None, doc_files: Optional[list] = None) -> Conversation:
        """
        update() method is used to update a conversation by uid.
        
        Args:
            conversation_uid (str): The conversation's id.
            chat_memory (list | optional): The conversation's chat memory.
            doc_files (list | optional): The conversation's doc files.
        
        
        Returns:
            Conversation: The updated conversation.
        """
        
        try:
            # Validate the arguments
            Validator.validate_requerd(conversation_uid, "conversation_uid")
            # Validate the arguments' types
            Validator.validate_string(conversation_uid, "conversation_uid")
            
            if chat_memory is not None and not isinstance(chat_memory, list):
                raise WaveException(f"The `chat_memory` is invalid ({type(chat_memory)}).")
            
            if doc_files is not None and not isinstance(doc_files, list):
                raise WaveException(f"The `doc_files` is invalid ({type(doc_files)}).")
            
            # Create a SQLAlchemy session
            session = Session()
            # Get the conversation by uid
            conversation = session.query(Conversation).filter_by(uid=conversation_uid).first()
            
            if chat_memory is not None:
                conversation.chat_memory = {'data': chat_memory}
            
            if doc_files is not None:
                conversation.doc_files = {'data': doc_files}
            
            conversation.updated_at = datetime.now()
            
            # Commit the session
            session.commit()
            # Close the session
            session.close()
            return conversation
        except WaveException as e:
            logger.error(e, code=e.code)
            raise
        except Exception as e:
            logger.error(f"An error occurred while updating a conversation by uid: {e}")
            raise Exception("An error occurred while updating a conversation by uid.") from e
    
    def delete(self, conversation_uid: str, user_uid: str) -> None:
        """
        delete() method is used to delete a conversation by uid.
        
        Args:
            conversation_uid (str): The conversation's id.
            user_uid (str): The user's id.
        
        Returns:
            None
        """
        
        try:
            # Validate the arguments
            Validator.validate_requerd(conversation_uid, "conversation_uid")
            Validator.validate_requerd(user_uid, "user_uid")
            # Validate the arguments' types
            Validator.validate_string(conversation_uid, "conversation_uid")
            Validator.validate_string(user_uid, "user_uid")
            
            # Check if the user exists
            user: User = Validator.is_user_exist(user_uid)
            # Create a SQLAlchemy session
            session = Session()
            # Get the conversation by uid
            conversation = session.query(Conversation).filter_by(uid=conversation_uid).first()
            if conversation is not None and (conversation.user_uid != user_uid and user.role != Role.ADMIN.value):
                raise NotAllowedException("You are not allowed to delete this conversation.")
            # Delete the conversation
            session.delete(conversation)
            # Commit the session
            session.commit()
            # Close the session
            session.close()
        except WaveException as e:
            logger.error(e, code=e.code)
            raise
        except Exception as e:
            logger.error(f"An error occurred while deleting a conversation by uid: {e}")
            raise Exception("An error occurred while deleting a conversation by uid.") from e
