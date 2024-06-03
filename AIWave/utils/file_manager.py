""" Built-in modules """
import os
import json
import shutil

""" Local modules """
from enums import FileType

class FileManager:
    __video_supported_formats = [
        "MP4",    # MPEG-4 Part 14
        "AVI",    # Audio Video Interleave
        "MKV",    # Matroska
        "MOV",    # QuickTime File Format
        "WMV",    # Windows Media Video
        "FLV",    # Flash Video
        "WebM",   # WebM Video
        "MPEG",   # MPEG (MPEG-1, MPEG-2)
        "3GP",    # 3GPP (3rd Generation Partnership Project)
    ]
    
    __audio_supported_formats = [
        "MP3",    # MPEG Audio Layer III
        "AAC",    # Advanced Audio Coding
        "WAV",    # Waveform Audio File Format
        "FLAC",   # Free Lossless Audio Codec
        "OGG",    # Ogg Vorbis
        "WMA",    # Windows Media Audio
        "M4A",    # MPEG-4 Audio
        "AIFF",   # Audio Interchange File Format
        "AMR",    # Adaptive Multi-Rate Audio Codec
    ]
    
    __image_supported_formats = [
        "JPG",    # Joint Photographic Experts Group
        "JPEG",   # Joint Photographic Experts Group
        "PNG",    # Portable Network Graphics
        "GIF",    # Graphics Interchange Format
        "TIFF",   # Tagged Image File Format
        "EPS",    # Encapsulated PostScript
        "AI",     # Adobe Illustrator Artwork
        "INDD",   # Adobe InDesign Document
        "RAW",    # Raw Image Formats
        "SVG",    # Scalable Vector Graphics
    ]
    
    # List of common video and audio formats supported in Veriblas.
    supported_formats = __video_supported_formats + __audio_supported_formats + __image_supported_formats

    @classmethod
    def is_supported_format(cls, filename: str) -> bool:
        """
        Check if the file is a supported format.
        
        Args:
            filename (str): The name of the file.
            
        Returns:
            bool: True if the file is a supported format, False otherwise.
            
        Examples:
            >>> FileManager.is_supported_format("video.mp4")
            True
        """
        file_ext: str = cls.get_file_extension(filename)
        return file_ext.upper() in cls.supported_formats
    
    @staticmethod
    def get_file_extension(filename: str) -> str:
        """
        Get the file extension.
        
        Args:
            filename (str): The name of the file.
            
        Returns:
            str: The file extension.
        
        Examples:
            >>> FileManager.get_file_extension("video.mp4")
            "mp4"
        """
        return os.path.splitext(filename)[1].lower().replace('.', '')
    
    @staticmethod
    def get_just_file_name(filename: str) -> str:
        """
        Get the file name without the extension.
        
        Args:
            filename (str): The name of the file.
            
        Returns:
            str: The file name without the extension.
        
        Examples:
            >>> FileManager.get_just_file_name("video.mp4")
            "video"
        """
        return os.path.splitext(filename)[0]

    @staticmethod
    def delete_file(file_path: str, remove_dir_if_empty: bool = False) -> None:
        """
        Delete a file.
        
        Args:
            file_path (str): The path to the file.
            remove_dir_if_empty (bool): If True, the directory will be removed if it is empty.
            
        Returns:
            None
            
        Raises:
            FileNotFoundError: If the file does not exist.
            
        Examples:
            >>> FileManager.delete_file("video.mp4")
            File 'video.mp4' was deleted successfully.
        """
        try:
            # Check if the file exists
            if not os.path.isfile(file_path):
                print(f"File '{file_path}' does not exist.")
                return

            # Delete the file
            os.remove(file_path)
            print(f"File '{file_path}' was deleted successfully.")
            
            if remove_dir_if_empty:
                # Remove the directory if it is empty
                directory: str = os.path.dirname(file_path)
                if len(os.listdir(directory)) == 0:
                    os.rmdir(directory)
                    print(f"Directory '{directory}' was removed successfully.")

        except Exception as e:
            print(f"Error while deleting the file: {e}")
    
    @staticmethod
    def move_file(src: str, dst: str) -> None:
        """
        Move a file.
        
        Args:
            src (str): The source file path.
            dst (str): The destination file path.
            
        Returns:
            None
            
        Raises:
            FileNotFoundError: If the source file does not exist.
            
        Examples:
            >>> FileManager.move_file("video.mp4", "videos/video.mp4")
            File 'video.mp4' was moved successfully.
        """
        try:
            # Check if the source file exists
            if not os.path.isfile(src):
                print(f"File '{src}' does not exist.")
                return

            # Move the file
            shutil.move(src, dst)
            print(f"File '{src}' was moved successfully.")
        except Exception as e:
            print(f"Error while moving the file: {e}")
    
    @classmethod
    def get_file_type(cls, filename: str) -> FileType:
        """
        Get the file type.
        
        Args:
            filename (str): The name of the file.
            
        Returns:
            FileType: The file type.
            
        Examples:
            >>> FileManager.get_file_type("video.mp4")
            FileType.VIDEO
        """
        file_ext: str = cls.get_file_extension(filename)
        if file_ext.upper() in cls.__video_supported_formats:
            return FileType.VIDEO
        elif file_ext.upper() in cls.__audio_supported_formats:
            return FileType.AUDIO
        elif file_ext.upper() in cls.__image_supported_formats:
            return FileType.IMAGE
        elif file_ext.upper() in cls.__document_supported_formats:
            return FileType.DOCUMENT
        elif file_ext.upper() in cls.__database_supported_formats:
            return FileType.DATABASE
        else:
            return FileType.OTHER
    
    @staticmethod
    def get_file_name_form_path(file_path: str) -> str:
        """
        Get the file name from the file path.
        
        Args:
            file_path (str): The file path.
            
        Returns:
            str: The file name.
            
        Examples:
            >>> FileManager.get_file_name_form_path("C:/Users/username/Desktop/video.mp4")
            "video.mp4"
        """
        return os.path.basename(file_path)
    
    @staticmethod
    def file_exists(file_path: str) -> bool:
        """
        Check if the file exists.
        
        Args:
            file_path (str): The file path.
            
        Returns:
            bool: True if the file exists, False otherwise.
            
        Examples:
            >>> FileManager.file_exists("C:/Users/username/Desktop/video.mp4")
            True
        """
        return os.path.isfile(file_path)
    
    @staticmethod
    def get_file_dir(file_path: str) -> str:
        """
        Get the file directory.
        
        Args:
            file_path (str): The file path.
            
        Returns:
            str: The file directory.
            
        Examples:
            >>> FileManager.get_file_dir("C:/Users/username/Desktop/video.mp4")
            "C:/Users/username/Desktop"
        """
        return os.path.dirname(file_path)
    
    @staticmethod
    def clear_directory(directory: str) -> None:
        """
        Clear the directory.
        
        Args:
            directory (str): The directory path.
            
        Returns:
            None
            
        Examples:
            >>> FileManager.clear_directory("C:/Users/username/Desktop")
            Directory 'C:/Users/username/Desktop' was cleared successfully.
        """
        try:
            # Check if the directory exists
            if not os.path.isdir(directory):
                print(f"Directory '{directory}' does not exist.")
                return

            # Clear the directory
            for file in os.listdir(directory):
                file_path = os.path.join(directory, file)
                if os.path.isfile(file_path):
                    os.unlink(file_path)
            print(f"Directory '{directory}' was cleared successfully.")

        except Exception as e:
            print(f"Error while clearing the directory: {e}")
    
    @staticmethod
    def read_text_file(file_path: str) -> str:
        """
        Read the text file.
        
        Args:
            file_path (str): The file path.
            
        Returns:
            str: The text file content.
            
        Examples:
            >>> FileManager.read_text_file("C:/Users/username/Desktop/text.txt")
            "Hello, World!"
        """
        # Check if the file exists
        if not os.path.isfile(file_path):
            print(f"File '{file_path}' does not exist.")
            return
        
        with open(file_path, "r") as file:
            return file.read()
        
    @staticmethod
    def read_json_file(file_path: str) -> dict:
        """
        Read the JSON file.
        
        Args:
            file_path (str): The file path.
            
        Returns:
            dict: The JSON file content.
            
        Examples:
            >>> FileManager.read_json_file("C:/Users/username/Desktop/data.json")
            {"name": "John", "age": 30}
        """
        # Check if the file exists
        if not os.path.isfile(file_path):
            print(f"File '{file_path}' does not exist.")
            return
    
        with open(file_path, "r") as file:
            return json.load(file)

    @staticmethod
    def read_srt_file(file_path: str) -> list:
        """
        Read the SRT file.
        
        Args:
            file_path (str): The file path.
            
        Returns:
            list: The SRT file content.
            
        Examples:
            >>> FileManager.read_srt_file("C:/Users/username/Desktop/subtitles.srt")
            [
                {
                    "index": 1,
                    "start": "00:00:00,000",
                    "end": "00:00:01,000",
                    "text": "Hello, World!"
                },
                {
                    "index": 2,
                    "start": "00:00:01,000",
                    "end": "00:00:02,000",
                    "text": "How are you?"
                }
            ]
        """
        # Check if the file exists
        if not os.path.isfile(file_path):
            print(f"File '{file_path}' does not exist.")
            return

        # Read the SRT file
        srt_data: list = []
        with open(file_path, "r") as file:
            lines: list = file.readlines()
            for line in lines:
                line = line.strip()
                if line == "":
                    continue
                if line.isdigit():
                    index: int = int(line)
                    continue
                if "-->" in line:
                    start, end = line.split("-->")
                    start = start.strip()
                    end = end.strip()
                    continue
                if line != "":
                    srt_data.append({
                        "index": index,
                        "start": start,
                        "end": end,
                        "text": line
                    })
        return srt_data
    
    @classmethod
    def read_content(cls, file_path: str):
        """
        Read the file content.
        
        Args:
            file_path (str): The file path.
            
        Returns:
            str: The file content.
            
        Examples:
            >>> FileManager.read_content("C:/Users/username/Desktop/text.txt")
            "Hello, World!"
        """
        # Check if the file exists
        if not os.path.isfile(file_path):
            print(f"File '{file_path}' does not exist.")
            return
        
        file_extenstion: str = cls.get_file_extension(cls.get_file_name_form_path(file_path))
        if file_extenstion == "srt":
            return cls.read_srt_file(file_path)
        elif file_extenstion in ["txt", "md"]:
            return cls.read_text_file(file_path)
        else:
            return None

    @staticmethod
    def normalize_path(path: str) -> str:
        """
        Normalize a file path by converting mixed separators to the platform-specific separator.

        Args:
            path (str): The input path with mixed separators.

        Returns:
            str: The normalized path with platform-specific separators.

        Example:
            >>> input_path = "\\storage\\backend\\x\\videos/d6f525494a044aa1a4af3daac9018541.mp4"
            >>> normalize_path(input_path)
            '/storage/backend/x/videos/d6f525494a044aa1a4af3daac9018541.mp4'
        """
        return os.path.normpath(path)
