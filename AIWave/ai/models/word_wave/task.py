from enum import Enum

class WaveTask(Enum):
    transcribe  = 'transcribe'
    translate   = 'translate'
    defualt     = 'defualt'
    
    @classmethod
    def from_str(cls, task: str) -> 'WaveTask':
        """
        Get the WaveTask from the string.
        
        Args:
            task (str): The task string.
        
        Returns:
            WaveTask: The WaveTask object.
        """
        for t in cls:
            if t.value == task:
                return t
        return cls.defualt
