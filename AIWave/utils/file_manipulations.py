""" Built-in modules """
import os
import re
import json

""" Third-party modules """
import markdown

""" Local modules """

from typing import Optional


def srt_to_json(input_file, output_file) -> Optional[str]:
    """
    Convert an SRT file to a JSON file.
    
    Args:
        input_file (str): The input SRT file path.
        output_file (str): The output JSON file path.
        
    Returns:
        Optional[str]: The output JSON file path.
    
    Raises:
        RuntimeError: If an error occurs while converting the SRT file to a JSON file.
    
    Examples:
        >>> srt_to_json('data/test.srt', 'data/test.json')
    
    """
    try:
        # Initialize a list to store subtitle data
        subtitles = []

        # Read the SRT file
        with open(input_file, 'r', encoding='utf-8') as file:
            lines = file.readlines()

        # Initialize variables to store subtitle data
        start_time = ""
        end_time = ""
        text = ""

        for line in lines:
            # Remove leading/trailing whitespace
            line = line.strip()

            # Check if the line is a number (indicating the subtitle index)
            if line.isdigit():
                # If start_time, end_time, and text are not empty, add to the subtitles list
                if start_time and end_time and text:
                    subtitles.append({
                        'start': start_time,
                        'end': end_time,
                        'text': text
                    })

                # Reset variables for the next subtitle
                start_time = ""
                end_time = ""
                text = ""
            elif re.match(r'\d+:\d+:\d+,\d+ --> \d+:\d+:\d+,\d+', line):
                # Parse start_time and end_time from the time format
                start_time, end_time = re.findall(r'(\d+:\d+:\d+,\d+)', line)
            elif line:
                # Accumulate lines of text within the subtitle
                text += line

        # Add the last subtitle to the list
        if start_time and end_time and text:
            subtitles.append({
                'start': start_time,
                'end': end_time,
                'text': text
            })

        # Write the subtitles to a JSON file
        with open(output_file, 'w', encoding='utf-8') as json_file:
            json.dump(subtitles, json_file, indent=4, ensure_ascii=False)
        
        return output_file
    except Exception as e:
        raise RuntimeError(f"Error converting the SRT file to a JSON file: {e}") from e

def convert_readme_to_html(readme_path: str) -> str:
    """
    Convert the content of a README file to HTML.

    Args:
        readme_path (str): The path to the README file.

    Returns:
        str: The HTML content of the README file.

    Raises:
        FileNotFoundError: If the specified README file does not exist.
    """
    try:
        # Read the README file and convert it to HTML
        with open(readme_path, 'r', encoding='utf-8') as file:
            readme_content = file.read()
            html_content = markdown.markdown(readme_content)
        
        return html_content

    except FileNotFoundError:
        raise FileNotFoundError(f"README file not found at path: {readme_path}")

def save_to_md_file(user_uid:str, content: str, file_name: Optional[str] = None, file_dir: Optional[str] = None) -> str:
    """
    Save the content to the markdown file.
    
    Note: The file name should end with `.md`.
    
    Args:
        user_uid (str): The user's uid.
        content (str): The content to save.
        file_name (str, optional): The file name. Defaults to None.
        file_dir (str, optional): The file directory. Defaults to None.
    
    Returns:
        str: The file path.
    """
    from utils.project_paths import ProjectPaths
    
    if file_dir is None:
        from enums.file_type import FileType
        from utils.secure_utilies import secure_filename
        
        file_dir: str = ProjectPaths.user_backend_type_dir(
            user_uid         = secure_filename(user_uid),
            backend_type    = FileType.DOCUMENT,
        )
                        
    if file_name is None:
        import uuid
        from utils.secure_utilies import secure_filename
        
        # Save the output to the pdf file
        file_id = secure_filename(str(uuid.uuid4().hex))
        
        file_ext: str = '.md'
        file_name: str = file_id + file_ext
        
    file_path: str = file_dir + '/' + file_name
    
    # Open the file
    with open(file_path, 'w') as file:
        # Write the content to the file
        file.write(content)
    
    return file_path.replace(ProjectPaths.project_root, '')
