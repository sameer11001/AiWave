""" Built-in modules """
import os
from typing import Optional

""" Local modules """
from enums.file_type import FileType

class ProjectPaths:
    # Get the current directory (the directory where this script is located)
    current_directory = os.path.dirname(os.path.abspath(__file__))

    # Define project folder paths
    project_root = os.path.abspath(os.path.join(current_directory, os.pardir))

    # Define subfolder paths relative to the project root
    assets_dir = os.path.join(project_root, "assets")
    static_dir = os.path.join(project_root, "flask_app/static")
    templates_dir = os.path.join(project_root, "flask_app/templates")
    database_dir = os.path.join(project_root, "database")
    ui_dir = os.path.join(project_root, "ui")
    logs_dir = os.path.join(project_root, "logs")
    
    # Define Folder paths relative to the project root
    storage_dir = os.path.join(project_root, "storage")
    instance_dir = os.path.join(storage_dir, "instance")
    temp_dir = os.path.join(storage_dir, "temp")
    models_dir = os.path.join(project_root, "models")
    
    # Define subfolder paths relative to the storage folder.
    frontend_dir = os.path.join(storage_dir, "frontend")
    backend_dir = os.path.join(storage_dir, "backend")
    
    @classmethod
    def init(cls) -> None:
        """
        Initialize the project paths.
        
        Args:
            None
        
        Returns:
            None
        
        Examples:
            >>> ProjectPaths.init()
        """
       
        os.makedirs(cls.instance_dir, exist_ok=True)
        os.makedirs(cls.temp_dir, exist_ok=True)
        os.makedirs(cls.storage_dir, exist_ok=True)
        os.makedirs(cls.models_dir, exist_ok=True)

        os.makedirs(cls.frontend_dir, exist_ok=True)
        os.makedirs(cls.backend_dir, exist_ok=True)
       
    
    @classmethod
    def user_dir(cls, base_dir:str, user_uid: str) -> str:
        """
        Get the user directory.
        
        Args:
            base_dir (str): The base directory.
            user_uid (str): The user ID.
            
        Returns:
            str: The user directory.
        
        Examples:
            >>> ProjectPaths.user_dir(ProjectPaths.storage_dir, 'user_uid')
            '/home/user/project/storage/user_uid'
        
        """
        folder_dir = os.path.join(base_dir, user_uid)
        os.makedirs(folder_dir, exist_ok=True)
        return folder_dir
    
    @classmethod
    def user_frontend_dir(cls, user_uid: Optional[str] = None) -> str:
        """
        Get the user frontend directory.
        
        Args:
            user_uid (str): The user ID.
            
        Returns:
            str: The user frontend directory.
        
        Examples:
            >>> ProjectPaths.user_frontend_dir('user_uid')
            '/home/user/project/storage/frontend/user_uid'
        
        """
        if user_uid is None:
            user_uid = ''
        return cls.user_dir(ProjectPaths.frontend_dir, user_uid)
    
    @classmethod
    def user_backend_dir(cls, user_uid: str) -> str:
        """
        Get the user backend directory.
        
        Args:
            user_uid (str): The user ID.
            
        Returns:
            str: The user backend directory.
        
        Examples:
            >>> ProjectPaths.user_backend_dir('user_uid')
            '/home/user/project/storage/backend/user_uid'
        
        """
        return cls.user_dir(ProjectPaths.backend_dir, user_uid)
    
    @classmethod
    def user_backend_type_dir(cls, user_uid: str, backend_type: Optional[FileType] = FileType.OTHER) -> str:
        """
        Get the user backend directory.
        
        Args:
            user_uid (str): The user ID.
            backend_type (FileType): The backend type.
            
        Returns:
            str: The user backend directory.
        
        Examples:
            >>> ProjectPaths.user_backend_type_dir('user_uid', FileType.IMAGES)
            '/home/user/project/storage/backend/user_uid/images'
        """
        return cls.user_dir(ProjectPaths.user_backend_dir(user_uid), backend_type.value)

# Initialize the project paths
ProjectPaths.init()
