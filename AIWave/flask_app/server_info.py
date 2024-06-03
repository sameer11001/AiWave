import os
from typing import Optional
from flask import Flask


class ServerInfo:
    """
    Server info class to store server information.
    
    Attributes:
        host (str): Server host address.
        port (str): Server port number.
    """
    host_key: str = 'SERVER_HOST'
    port_key: str = 'SERVER_PORT'
    
    host: str = '0.0.0.0'
    port: int = 7651
    
    app: Optional[Flask] = None
    
    @classmethod
    def init(cls):
        """
        Initialize the server info.
        """
        # Get the host and port from the environment variables if they exist.
        os.environ[cls.host_key] = os.environ.get(cls.host_key, cls.host)
        os.environ[cls.port_key] = os.environ.get(cls.port_key, str(cls.port))
        
        # Set the host and port.
        cls.host = os.environ[cls.host_key]
        cls.port = int(os.environ[cls.port_key])

# Initialize the server info.
ServerInfo.init()