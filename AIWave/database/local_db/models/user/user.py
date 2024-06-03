""" Built-in modules """
from typing import Any, Dict, Optional

""" Third-party modules """
from sqlalchemy.orm import relationship # Import the RelationShip to link the tables.
from sqlalchemy import Column, Integer, String, DateTime, JSON # Import the SqlAlchemy Data types.

""" Local modules """
from database.local_db import Base


class User(Base):
    
    """
    User class represents a user entity.
    
    Attributes:
        uid (int): The user's id.
        email (str): The user's email.
        password (str): The user's password.
        username (str | optional): The user's name.
        image_url (str | optional): The user's image url.
        age (int | optional): The user's age.
        role (str | optional): The user's role.
        data (Dict[str, Any] | optional): The user's data.
        created_at (datetime): The user's creation date.
        updated_at (datetime | optional): The user's last update date.
        
    
    Methods:
        to_map: Convert the object to a dictionary.
            
    Usage:
        user = User(
            email='test@example.com',
            username='test',
            age=10,
            role='user',
            data={'test': 'test'},
            created_at=datetime.now(),
            updated_at=datetime.now(),
        )
    """

    __tablename__ = 'DF_User'

    # id                  = Column(Integer, primary_key=True)
    uid                 = Column(String(100), primary_key=True)
    
    email               = Column(String(256), nullable=False)
    password            = Column(String(256), nullable=False)
    
    username            = Column(String(100), nullable=True)
    image_url           = Column(String(256), nullable=True)
    age                 = Column(Integer, nullable=True)
    role                = Column(String(100), nullable=True, default='user')
    data                = Column(JSON, nullable=True)
    created_at          = Column(DateTime, nullable=False)
    updated_at          = Column(DateTime, nullable=True)
    
    media               = relationship('Media', backref='user', lazy='joined')
    
    conversations        = relationship('Conversation', backref='user', lazy='joined')
    
    def to_map(self, show_media: bool = False) -> Dict[str, Any]:
        """
        Convert the object to a dictionary.
        
        Args:
            show_media (bool): Whether to show the user's media.
        
        Returns:
            dict: The dictionary representation of the object.
        """
        return {
            # 'id': self.id,
            'uid': self.uid,
            'email': self.email,
            'username': self.username,
            'image_url': self.image_url,
            'age': self.age,
            'role': self.role,
            'data': self.data,
            'media': [m.to_map() for m in self.media] if show_media else "...",
            'created_at': self.created_at,
            'updated_at': self.updated_at,
        }

    def get_conversation(self, conversation_uid: str, prefix: Optional[str] = "") -> Any:
        """
        Get the conversation with the given conversation_uid.
        
        Args:
            conversation_uid (str): The conversation's uid.
            prefix (str): The uid prefix key
        
        Returns:
            Conversation: The conversation with the given conversation_uid.
        """
        for conversation in self.conversations:
            uid: str = conversation.uid
            if uid == conversation_uid and uid.__contains__(prefix):
                return conversation
        return None
    
    def copy(self) -> Any:
        """
        Copy the user.
        
        Returns:
            User: The copied user.
        """
        return User(
            uid=self.uid,
            email=self.email,
            password=self.password,
            username=self.username,
            image_url=self.image_url,
            age=self.age,
            role=self.role,
            data=self.data,
            created_at=self.created_at,
            updated_at=self.updated_at,
        )
