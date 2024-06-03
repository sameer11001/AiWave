from enum import Enum

class ResearcheSource(Enum):
    ARXIV = 'arxiv'
    WIKI  = 'wiki'
    
    @classmethod
    def from_str(cls, source: str) -> 'ResearcheSource':
        """
        Get the ResearcheSource from the string.
        
        Args:
            source (str): The source string.
        
        Returns:
            ResearcheSource: The ResearcheSource object.
        """
        for t in cls:
            if t.value == source:
                return t
        
        raise ValueError(f"Invalid source: {source}, Please provide a valid source. (arxiv, wiki)")
