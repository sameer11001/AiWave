""" Built-in modules """
from typing import List, Optional

""" Local modules """
from database.local_db.models import (
    AIProcess,
)

def get_file_paths_from_ai_process(ai_process: dict) -> List[str]:
    """
    Get the file paths from the ai process.
    
    Args:
        ai_process (dict): The ai process.
    
    Returns:
        List[str]: The file paths.
    """
    from utils import ProjectPaths
    from ai.models import WordWave, VisionWave
    
    file_paths = []
    # Check if the ai process is a word wave.
    if ai_process['model_key'] == WordWave.model_key:
        data: list = ai_process['data'].get('data', [])
        for d in data:
            # Get the file path.
            file_path: str = d.get('path', None)
            if file_path: file_path: str = ProjectPaths.project_root + '/' + file_path
            # Add the file path to the file paths
            file_paths.append(file_path)
    elif ai_process['model_key'] == VisionWave.model_key:
        file_path: Optional[dict] = ai_process['data'].get('output_file', None)
        if file_path: file_path: Optional[str] = file_path.get('path', None)
        if file_path: file_path: str = ProjectPaths.project_root + '/' + file_path
        # Add the file path to the file paths
        file_paths.append(file_path)
    
    # Filter the file paths.
    file_paths = list(filter(lambda x: x is not None, file_paths))
    return file_paths

def get_file_paths_from_ai_processes(ai_processes: Optional[List[AIProcess]]) -> List[str]:
    """
    Get the file paths from the ai processes.
    
    Args:
        ai_processes (List[AIProcess]): The ai processes.
    
    Returns:
        List[str]: The file paths.
    """
    # Check if the ai process is not None or empty.
    if ai_processes is None or len(ai_processes) == 0: return []
    
    file_paths = []
    for ai_process in ai_processes:
        file_paths += get_file_paths_from_ai_process(ai_process.to_map())
    return file_paths
