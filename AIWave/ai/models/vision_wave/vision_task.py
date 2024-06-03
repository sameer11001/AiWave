from enum import Enum

class VisionTask(Enum):
    """
    The VisionTask enum.
    """
    detect    = 'detect'
    pose      = 'pose'
    seg       = 'seg'
    
    @classmethod
    def from_str(cls, task: str) -> 'VisionTask':
        """
        Get the VisionTask from a string.

        Args:
            task (str): The task string.

        Returns:
            VisionTask: The VisionTask enum.

        Raises:
            ValueError: If the task string is invalid.
        """
        if task == 'detect':
            return VisionTask.detect
        elif task == 'pose':
            return VisionTask.pose
        elif task == 'seg':
            return VisionTask.seg
        else:
            raise ValueError(f"Invalid task {task}. Please provide a valid task. (detect, pose, seg)")
