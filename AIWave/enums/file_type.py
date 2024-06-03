from enum import Enum

class FileType(Enum):
    """Enum for file types"""
    IMAGE = 'images'
    AUDIO = 'audios'
    VIDEO = 'videos'
    DOCUMENT = 'documents'
    DATABASE = 'databases'
    OTHER = 'others'
