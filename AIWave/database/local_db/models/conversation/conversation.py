""" Built-in modules """
from typing import Any, Dict

""" Third-party modules """
from sqlalchemy import Column, String, ForeignKey, DateTime, JSON # Import the SqlAlchemy Data types.

""" Local modules """
from database.local_db import Base

class Conversation(Base):
    """
    Conversation class represents a conversation entity.
    
    Attributes:
        uid (int): The conversation's id.
        user_uid (str): The user's id.
        chat_memory (Dict[str, Any] | optional): The conversation's chat memory.
        doc_files (Dict[str, Any] | optional): The conversation's doc files.
        created_at (datetime): The conversation's creation date.
    
    Methods:
        to_map: Convert the object to a dictionary.
    
    Usage:
        conversation = Conversation(
            user_uid='test',
            chat_memory={'test': 'test'},
            doc_files={'test': 'test'},
            created_at=datetime.now(),
        )
    """
    
    __tablename__ = 'DF_Conversation'
    
    uid                 = Column(String(100), primary_key=True)
    
    user_uid            = Column(String(100), ForeignKey('DF_User.uid'), nullable=False)
    
    model_name          = Column(String(100), nullable=True)
    chat_memory: Dict[str, any]         = Column(JSON, nullable=True)
    doc_files           = Column(JSON, nullable=True)
    
    created_at          = Column(DateTime, nullable=False)
    updated_at          = Column(DateTime, nullable=True)
    
    def to_map(self)-> Dict[str, Any]:
        """
        Convert the object to a dictionary.
        
        Args:
            None
        
        Returns:
            Dict[str, Any]: The object as a dictionary.
        """
        return {
            'uid': self.uid,
            'user_uid': self.user_uid,
            'model_name': self.model_name,
            'chat_memory': self.chat_memory,
            'doc_files': self.doc_files,
            'created_at': self.created_at,
        }
    
    def copy(self):
        """
        Create a copy of the object.
        
        Args:
            None
        
        Returns:
            Conversation: The copied object.
        """
        return Conversation(
            uid         = self.uid,
            user_uid    = self.user_uid,
            model_name  = self.model_name,
            chat_memory = self.chat_memory,
            doc_files   = self.doc_files,
            created_at  = self.created_at,
            updated_at  = self.updated_at,
        )
