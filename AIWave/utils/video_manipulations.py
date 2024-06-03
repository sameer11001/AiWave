""" Built-in modules """
import os
import cv2
import subprocess
from typing import Optional

""" Local modules """
from utils.file_manager import FileManager
from utils.project_paths import ProjectPaths


def generate_video_thumbnail(video_path: str, prefix_path: Optional[str] = None) -> Optional[str]:
    """
    Generate a thumbnail for a video file.
    
    Args:
        video_path (str): The path to the video file.
        prefix_path (str): The path prefix to be added to the thumbnail path.
    
    Returns:
        Optional[str]: The path to the thumbnail file.
    
    Raises:
        None
    
    Examples:
        >>> generate_video_thumbnail('path/to/video.mp4')
        'path/to/video_thumbnail.jpg'
    """
    try:
        # Check if the video prefix path is set
        if prefix_path is None:
            prefix_path = ProjectPaths.project_root
        # Generate the full path to the video file
        full_path: str = prefix_path + video_path
        # Read the video file
        cap = cv2.VideoCapture(full_path)
        success, frame = cap.read()
        # Check if the video was read successfully
        if not success:
            raise Exception('Error reading video file')

        # Generate the thumbnail path
        thumbnail_path = full_path.replace('.mp4', '_thumbnail.jpg')

        # Save the thumbnail
        cv2.imwrite(thumbnail_path, frame)
        # Release the video capture
        cap.release()

        return thumbnail_path.replace(ProjectPaths.project_root, '')
    except Exception as e:
        print(f"Error generating thumbnail for video: {str(e)}")
        return None

def extract_audio(video_file_path: str) -> str:
    """
    Extract the audio from a video file.
    
    Args:
        video_file_path (str): The video file path.
        
    Returns:
        str: The audio file path.
    
    Raises:
        RuntimeError: If an error occurs while extracting the audio from the video file.
    
    Examples:
        >>> extract_audio('path/to/video.mp4')
        'path/to/video.wav'
    """
    try:
        # Get the video file name
        video_file_name = os.path.basename(video_file_path).split('.')[0]
        # Create the audio file path   
        audio_file = f'{ProjectPaths.temp_dir}/{video_file_name}.wav'
        
        # Check if the audio file exists
        if FileManager.file_exists(audio_file):
            print("Deleting the audio file.")
            # Remove the audio file if it exists.
            FileManager.delete_file(audio_file)
        
        command = ["ffmpeg", "-i", video_file_path, "-ac", "1", "-ar", "16000","-vn", "-f", "wav", audio_file]
        # Run the command without printing output.
        subprocess.run(command, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        return audio_file
    except Exception as e:
        print(f"Error extracting audio from video file: {e}")
        raise RuntimeError(f"Error extracting audio from video file") from e

def concate_audio_with_video(video_file_path: str, audio_file_path: str) -> str:
    """
    Concatenate a video and audio file.
    
    Args:
        video_file_path (str): The video file path.
        audio_file_path (str): The audio file path.

    Returns:
        str: The path to the concatenated video file.
    
    Raises:
        RuntimeError: If an error occurs while concatenating the video and audio files.
    
    Examples:
        >>> concate_audio_video('path/to/video.mp4', 'path/to/audio.wav')
        'path/to/video.wav'
    """
    try:
        # Get the video file name
        video_file_name = os.path.basename(video_file_path).split('.')[0]
        
        # Create the output file path   
        output_file = f'{ProjectPaths.temp_dir}/{video_file_name}_output.mp4'
        
        # Check if the output file exists
        if FileManager.file_exists(output_file):
            print("Deleting the output file.")
            # Remove the output file if it exists.
            FileManager.delete_file(output_file)
        
        command = ["ffmpeg", "-i", video_file_path, "-i", audio_file_path, "-c:v", "copy", "-c:a", "aac", "-map", "0:v:0", "-map", "1:a:0", "-shortest", output_file]
        # Run the command without printing output.
        subprocess.run(command, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        
        # Delete the original video file
        FileManager.delete_file(video_file_path)
        # Get the video file path without the '_withoutsound' suffix
        new_video_file_path = video_file_path.replace('_withoutsound', '')
        # Move the output file to the video file path and rename it to the video file name
        FileManager.move_file(output_file, new_video_file_path)

        return output_file
    except Exception as e:
        raise RuntimeError(f"Error concatenating video and audio files: {e}") from e

def concat_srt_with_video(video_file_path: str, srt_file: str, output_file:str, subtitle_lang: str ='eng', author: str ='Mohamad Aboud') -> str:
    """
    Concatenate the SRT file with the original video.
    
    Args:
        video_file_path (str): The video file path.
        srt_file (str): The SRT file path.
        output_file (str): The output file path.
        subtitle_lang (str): The subtitle language.
        author (str): The author.
    
    Returns:
        str: The output file path.
        
    Raises:
        RuntimeError: If an error occurs while concatenating the SRT file with the original video.
    
    Examples:
        >>> concat_srt_with_video('data/test.mp4', 'data/test.srt', 'data/test_transcribe.mp4')
        'data/test_transcribe.mp4'
    """
    
    try:
        command = [
            "ffmpeg",
            "-i", video_file_path,
            "-i", srt_file,
            "-c:v", "copy",
            "-c:a", "copy",
            "-c:s", "mov_text",
            "-metadata:s:s:0", f"language={subtitle_lang}",
            "-metadata:s:s:0", f"title={author}",
            output_file
        ]
        
        subprocess.run(command, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        
        # Get the srt file name
        srt_file_name = FileManager.get_file_name_form_path(srt_file)
        # Get the video file name
        video_file_name = FileManager.get_file_name_form_path(video_file_path)
        # Get the output file dir
        output_file_dir = FileManager.get_file_dir(output_file)
        
        print(f"Concatenating: \n    Srt file: `{srt_file_name}` with\n    Video file: `{video_file_name}` and saving to\n    Output: `{output_file_dir}`.")

        return output_file
    except Exception as e:
        raise RuntimeError(f"Error concatenating the SRT file with the original video: {e}") from e
   