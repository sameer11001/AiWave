""" Built-in modules """
from typing import Any, Dict

""" Third-party modules """
from sqlalchemy.orm import relationship # Import the RelationShip to link the tables.
from sqlalchemy import Column, String, DateTime, ForeignKey, JSON # Import the SqlAlchemy Data types.

""" Local modules """
from database.local_db import Base

class Media(Base):
        """
        Media class represents a media entity.
        
        Attributes:
            id (int): The media's id.
            user_uid (str): The user's id.
            file_id (str): The file's id.
            file_name (str): The file's name.
            file_type (str): The file's type.
            file_path (str): The file's path.
            file_url (str): The file's url.
            thumbnail_url (str | optional): The file's thumbnail url.
            data (Dict[str, Any] | optional): The media's data.
            status (List[Status] | optional): The media's status.
            ai_process (List[AIProcess] | optional): The media's ai_process.
            created_at (datetime): The media's creation date.
            updated_at (datetime | optional): The media's last update date.
            
        
        Methods:
            to_map: Convert the object to a dictionary.
                
        Usage:
            media = Media(
                user_uid='test',
                file_name='test',
                file_type='test',
                file_path='test',
                file_url='test',
                thumbnail_url='test',
                data={'test': 'test'},
                created_at=datetime.now(),
                updated_at=datetime.now(),
            )
        """
        
        __tablename__ = 'DF_Media'

        uid                 = Column(String(100), primary_key=True)
        
        user_uid            = Column(String(100), ForeignKey('DF_User.uid'), nullable=False)
        file_name           = Column(String(100), nullable=False)
        file_type           = Column(String(10), nullable=False)
        file_path           = Column(String(265), nullable=False)
        file_url            = Column(String(256), nullable=False)
        thumbnail_url       = Column(String(256), nullable=True)
        data                = Column(JSON, nullable=True)
        created_at          = Column(DateTime, nullable=False)
        updated_at          = Column(DateTime, nullable=True)
        
        
        ai_process          = relationship('AIProcess', backref='media', lazy='joined')
        
        
        
        def to_map(self, show_ai_process: bool = True) -> Dict[str, Any]:
            """
            Convert the object to a dictionary.
            
            Args:
                show_ai_process (bool, optional): If True, the ai_process will be included in the dictionary. Defaults to False.
            
            Returns:
                Dict[str, Any]: The object as a dictionary.
            """
            return {
                'uid': self.uid,
                'user_uid': self.user_uid,
                'file_name': self.file_name,
                'file_type': self.file_type,
                'file_path': self.file_path,
                'file_url': self.file_url,
                'thumbnail_url': self.thumbnail_url,
                'data': self.data,
                'ai_processes': [a.to_map() for a in self.ai_process] if show_ai_process else "...",
                'created_at': self.created_at,
                'updated_at': self.updated_at,
            }
    
        @classmethod
        def from_map(cls, map: Dict[str, Any]) -> 'Media':
            """
            Create a Media object from a dictionary.
            
            Args:
                map (Dict[str, Any]): The dictionary to create the object from.
                
            Returns:
                Media: The Media object.
            """
            return cls(
                id              = map['uid'],
                user_uid        = map['user_uid'],
                file_name       = map['file_name'],
                file_type       = map['file_type'],
                file_path       = map['file_path'],
                file_url        = map['file_url'],
                thumbnail_url   = map['thumbnail_url'],
                data            = map['data'],
                created_at      = map['created_at'],
                updated_at      = map['updated_at'],
            )
