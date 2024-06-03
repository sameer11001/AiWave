""" Built-in modules """
from typing import Any, Dict

""" Third-party modules """
from sqlalchemy import Column, String, ForeignKey, DateTime, JSON # Import the SqlAlchemy Data types.

""" Local modules """
from database.local_db import Base

class AIProcess(Base):
    """
    AIProcess class represents a AIProcess entity.
    
    Attributes:
        None
    
    Methods:
        None
    
    Usage:
        None
    """
    
    __tablename__ = 'DF_AIProcess'
    
    uid                 = Column(String(100), primary_key=True)
    
    media_uid           = Column(String(100), ForeignKey('DF_Media.uid'), nullable=False)
    model_name          = Column(String(50), nullable=False)
    task                = Column(String(50), nullable=True)
    model_key           = Column(String(25), nullable=False)
    data                = Column(JSON, nullable=True)
    created_at          = Column(DateTime, nullable=False)
    updated_at          = Column(DateTime, nullable=True)
    
    def to_map(self) -> Dict[str, Any]:
        """
        Convert the object to a dictionary.
        
        Args:
            None
        
        Returns:
            Dict[str, Any]: The object as a dictionary.
        """
        return {
            'uid': self.uid,
            'media_uid': self.media_uid,
            'model_name': self.model_name,
            'task': self.task,
            'model_key': self.model_key,
            'data': self.data,
            'created_at': self.created_at,
            'updated_at': self.updated_at,
        }
    
    def copy(self) -> 'AIProcess':
        """
        Copy the object.
        
        Args:
            None
        
        Returns:
            AIProcess: The copied object.
        """
        return AIProcess(
            uid         = self.uid,
            media_uid   = self.media_uid,
            model_name  = self.model_name,
            task        = self.task,
            model_key   = self.model_key,
            data        = self.data,
            created_at  = self.created_at,
            updated_at  = self.updated_at,
        )
