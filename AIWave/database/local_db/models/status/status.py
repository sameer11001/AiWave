""" Built-in modules """
import json
import time
import uuid
from typing import Any, Dict, Optional

""" Local modules """
from database.local_db import r

class Status:
    """
    Status class represents a status dict.
    
    Attributes:
        uid (str): The uid of the status.
        model_name (str): The name of the model.
        state (str): The state of the status.
        state_message (str): The state message of the status.
        state_details (Dict[str, Any]): The state details of the status.
        progress (Dict[str, Any]): The progress of the status.
        timestamp (DateTime): The date and time the status was created.
    
    Methods:
        to_map: Convert the object to a dictionary.
            
    Usage:
        status = Status(
            model_name      = 'model_name',
            state           = 'state',
            state_message   = 'state_message',
            state_details   = {'state_details': 'state_details'},
            progress        = {'progress': 'progress'},
        )
    """
    
    def __init__(self, media_uid: str, model_name: str, state: str, state_message: str, uid: Optional[str] = None, state_details: Optional[Dict[str, Any]] = None, progress: Optional[Dict[str, Any]] = None, timestamp: Optional[str] = None) -> None:
        """
        Initialize the status.
        
        Args:
            media_uid (str): The uid of the media.
            model_name (str): The name of the model.
            state (str): The state of the status.
            state_message (str): The state message of the status.
            state_details (Dict[str, Any]): The state details of the status.
            progress (Dict[str, Any]): The progress of the status.
            timestamp (DateTime): The date and time the status was created.
            
        Returns:
            None
            
        Raises:
            None
        """
        self.uid             = uid if uid else uuid.uuid4().hex
        self.media_uid      = media_uid
        self.model_name     = model_name
        self.state          = state
        self.state_message  = state_message
        self.state_details  = state_details
        self.progress       = progress
        self.timestamp: str = timestamp if timestamp else time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())

    def to_map(self) -> Dict[str, Any]:
        """
        Convert the object to a dictionary.
        
        Args:
            
        Returns:
            Dict[str, Any]: Dictionary of the object.
        """
        return {
            'uid'           : self.uid,
            'media_uid'     : self.media_uid,
            'model_name'   : self.model_name,
            'state'        : self.state,
            'state_message': self.state_message,
            'state_details': self.state_details,
            'progress'     : self.progress,
            'timestamp'   : self.timestamp
        }
    
    def to_json(self) -> str:
        """
        Convert the object to a json.
        
        Args:
            
        Returns:
            str: JSON of the object.
        """
        return json.dumps(self.to_map())
    
    @classmethod
    def from_map(cls, status_map: Dict[str, Any]) -> 'Status':
        """
        Convert the dictionary to a status object.
        
        Args:
            status_map (Dict[str, Any]): The status dictionary.
            
        Returns:
            Status: The status object.
        """
        return cls(
            uid             = status_map['uid'],
            media_uid      = status_map['media_uid'],
            model_name      = status_map['model_name'],
            state           = status_map['state'],
            state_message   = status_map['state_message'],
            state_details   = status_map['state_details'],
            progress        = status_map['progress'],
            timestamp      = status_map['timestamp']
        )
    
    @classmethod
    def from_json(cls, status_json: str) -> 'Status':
        """
        Convert the json to a status object.
        
        Args:
            status_json (str): The status json.
            
        Returns:
            Status: The status object.
        """
        return cls.from_map(json.loads(status_json))
    
    
    def update(self, state: Optional[str] = None, state_message: Optional[str] = None, state_details: Optional[Dict[str, Any]] = None, progress: Optional[Dict[str, Any]] = None) -> None:
        """
        Update the status.
        
        Args:
            state (str): The state of the status.
            state_message (str): The state message of the status.
            state_details (Dict[str, Any]): The state details of the status.
            
        Returns:
            None
        
        Raises:
            Exception: If the update fails.
        """
        try:
            # Check if the arguments are valid.
            self.state          = state if state else self.state
            self.state_message  = state_message if state_message else self.state_message
            self.state_details  = state_details if state_details else self.state_details
            self.progress       = progress if progress else self.progress
            
            from database.local_db.models.status.update_status import UpdateStatus
            update_status = UpdateStatus(
                status_uid       = self.uid,
                state           = self.state,
                state_message   = self.state_message,
                state_details   = self.state_details,
                progress        = self.progress,
            )
            update_status.update()
        except Exception as e:
            raise e
