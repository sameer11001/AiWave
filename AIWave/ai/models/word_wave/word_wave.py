""" Built-in modules """
import os
from threading import Thread
from typing import Dict, List, Optional, Union

""" Third-party modules """
import torch
import whisper
from whisper.utils import get_writer

""" Local modules """
from enums import FileType
from .task import WaveTask
from logs import CustomLogger
from .step import WordWaveStep
from enums.process_state import ProcessState
from utils import (
    FileManager,
    ProjectPaths,
    extract_audio,
    concat_srt_with_video,
)

from database.local_db.models import (
    Media,
    Status,
    AddStatus,
    AIProcess,
    AIProcessController,
)

logger = CustomLogger("WordWave")


class WordWave(Thread):
    """
    The WordWave class.
    
    Attributes:
        media (Media): The media object to be processed.
        language_code (str): The language code to use for the transcription.
        audio_file_path (str): The audio file path.
        output_dir (str): The output directory.
        model (whisper.Whisper): The Wisper model.
        result (Dict[str, Union[str, list]]): The result.
        srt_file_path (str): The SRT file path.
        output_file (str): The output file path.
    """
    # Metadata
    model_name: str = "word_wave"
    model_key: str  = "ww"
    
    model: Optional[whisper.Whisper] = None 
    
    def __init__(self, media: Media, language_code: Optional[str] = 'auto', concat_srt: Optional[bool] = False, task: WaveTask = WaveTask.defualt, verbose: Optional[bool] = False) -> None:
        """
        Initialize the WordWave class with the specified video path and output path.
        
        Args:
            media (Media): The media object to be processed..
            language_code (str): The language code to use for the transcription.
            concat_srt (bool): The flag to concatenate the SRT file with the original video. by default False.
            task (WaveTask): The task to perform. by default WaveTask.defualt.
            verbose (bool, optional): The flag to print the status. Defaults to False.
            
        Returns:
            None
        """
        # Initialize the Thread class
        super().__init__()
        self.name = "WordWave"
        self.daemon = True
        # Initialize the class variables
        self.media: Media = media
        self.language_code: str = language_code
        self.concat_srt: bool = concat_srt
        self.task: WaveTask = task
        self.verbose: bool = verbose
        
        # Create a status record
        self.status: Status = self.create_status()
    
    def __initailize_attributes(self) -> None:
        """
        Initialize the WordWave process.
        
        Args:
            None
            
        Returns:
            None
        
        Raises:
            RuntimeError: If there is an error initializing the WordWave process.
        """
        # Update the status
        self.__update_status(f"Initalized the WordWave process started.")
        # Update the status progress
        self.__update_step_status(WordWaveStep.initialize, ProcessState.in_progress)
        # Initialize the WordWave process
        try:
            # Set the device
            self.device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
            # Set the word options
            self.word_options = {
                "highlight_words": True,
                "max_line_count": 50,
                "max_line_width": 3
            }
            # Initialize the model if it doesn't exist
            self.__create_wisper_model_if_not_exist()
        except Exception as e:
            # Update the status
            self.__update_status(f"Error initializing the WordWave process: {e}")
            # Update the status progress
            self.__update_step_status(WordWaveStep.initialize, ProcessState.failed)
            # Log the error
            logger.error(f"Error initializing the WordWave process: {e}")
            raise RuntimeError(f"Error initializing the WordWave process.") from e
        
        # Initialize the audio file path
        try:
            # Create the audio file path variable.
            self.audio_file_path: str = ProjectPaths.project_root + self.media.file_path
            # Get the file type.
            self.file_type: FileType = FileManager.get_file_type(self.media.file_name)
            # Check the file type is video.
            if self.file_type == FileType.VIDEO:
                # Update the status
                self.__update_status(f"Extracting audio from the video file: {self.media.file_name}")
                # Extract the audio from the video file.
                self.audio_file_path = extract_audio(
                    video_file_path = self.audio_file_path
                )
                # Update the status
                self.__update_status(f"Audio extracted from the video file: {self.media.file_name}")
            elif self.file_type == FileType.AUDIO:
                # Update the status
                self.__update_status(f"Audio file detected: {self.media.file_name}")
                # Set the audio file path to the media file path.
                pass
            else:
                # Raise an error if the file type is not supported.
                raise ValueError(f"Invalid file type: {self.media.file_type}")
        except Exception as e:
            # Update the status
            self.__update_status(f"Error processing the audio file: {e}")
            # Update the status progress
            self.__update_step_status(WordWaveStep.initialize, ProcessState.failed)
            # Log the error
            logger.error(f"Error processing the audio file: {e}")
            raise Exception(f"Error processing the audio file: {e}")
        
        # Get the directory name
        dirname = os.path.dirname(self.media.file_path)
        # Create the output directory
        self.output_dir: str = ProjectPaths.project_root + os.path.join(dirname, self.model_name, self.media.uid)
        # Create the output directory if it doesn't exist
        os.makedirs(self.output_dir, exist_ok=True)
        # Update the status
        self.__update_status(f"Initalized the WordWave process completed.")
        # Update the status progress
        self.__update_step_status(WordWaveStep.initialize, ProcessState.completed)
    
    def create_status(self) -> Status:
        """
        Create a new status record.
        
        Args:
            None
            
        Returns:
            Status: The status record.
        """
        prgress = {}
        # loop through the steps
        for step in WordWaveStep:
            # Add the step to the progress
            prgress[step.value] = ProcessState.pending.value
        
        add_status = AddStatus(
            media_uid     = self.media.uid,
            model_name    = self.model_name,
            state         = 'pending',
            state_message = 'Initialized the WordWave process.',
            state_details = None,
            progress      = prgress,
        )
        
        status = add_status.add()
        
        return status
    
    def __update_status(self, state_message: str, state: Optional[str] = None, state_details: Optional[Dict[str, str]] = None) -> None:
        """
        Update the status record.
        
        Args:
            state (str): The state of the status.
            state_message (str): The state message of the status.
            state_details (Dict[str, str], optional): The state details of the status. Defaults to None.
            
        Returns:
            None
        """
        # Update the status record
        self.status.update(
            state           = state,
            state_message   = state_message,
            state_details   = state_details,
        )
        
    def __update_step_status(self, step: WordWaveStep, state: ProcessState) -> None:
        """
        Update the status record.
        
        Args:
            step (WordWaveStep): The step.
            state (ProcessState): The state.
            
        Returns:
            None
        """
        progress = self.status.progress
        progress[step.value] = state.value
        
        # Update the status record
        self.status.update(
            state           = self.status.state,
            state_message   = self.status.state_message,
            progress        = progress
        )
    
    def get_status(self) -> Status:
        """
        Get the status record.
        
        Args:
            None
            
        Returns:
            Status: The status record.
        """
        return self.status
    
    def __create_wisper_model_if_not_exist(self) -> whisper.Whisper:
        """
        Create the Wisper model if it doesn't exist.
        
        Args:
            None
            
        Returns:
            whisper.Whisper: The Wisper model.
        """
        try:
            # Check if the model exists
            if self.model is None:
                # Update the status
                self.__update_status(f"Donwloading the word wave model.")
                # Create the Wisper model
                self.model = whisper.load_model("base").to(self.device)
            return self.model
        except Exception as e:
            logger.error(f"Error creating the word wave model: {e}")
            raise RuntimeError(f"Error creating the word wave model.") from e
    
    def __detect_language(self) -> None:
        """
        Detect the language of the audio.
        
        Args:
            None
            
        Returns:
            None
        """
        try:
            # Update the status progress
            self.__update_step_status(WordWaveStep.detect_language, ProcessState.in_progress)
            if not self.language_code or self.language_code == 'auto':
                # load audio and pad/trim it to fit 30 seconds
                audio = whisper.load_audio(self.audio_file_path)
                audio = whisper.pad_or_trim(audio)
                # make log-Mel spectrogram and move to the same device as the model
                mel = whisper.log_mel_spectrogram(audio).to(self.device)
                # Detect the language of the audio
                _, probs = self.model.detect_language(mel)
                # Get the language code
                self.language_code = max(probs, key=probs.get)
            else:
                pass
            # Print the result
            print(f"Language detected: {self.language_code}")
            # Update the status
            self.__update_status(f"Language detected: {self.language_code}")
            # Update the status progress
            self.__update_step_status(WordWaveStep.detect_language, ProcessState.completed)
        except Exception as e:
            # Update the status
            self.__update_status(f"Error detecting the language of the audio")
            # Update the status progress
            self.__update_step_status(WordWaveStep.detect_language, ProcessState.failed)
            raise Exception(f"Error detecting the language of the audio")
    
        
    def __delete_audio_file(self) -> None:
        """
        Delete the audio file.
        
        Args:
            None
        
        Returns:
            None
        """
        try:
            if self.file_type == FileType.VIDEO:
                # check if the audio file exists
                if os.path.isfile(self.audio_file_path):
                    # Delete the audio file
                    os.remove(self.audio_file_path)
        except Exception as e:
            logger.error(f"Error deleting the audio file: {e}")
    
    
    def clear_output_dir(self) -> None:
        """
        Clear the output directory.
        
        Args:
            None
            
        Returns:
            None
        """
        # Clear the output directory
        FileManager.clear_directory(self.output_dir)
        
    def __start_process(self, task: Optional[WaveTask] = None) -> dict[str, Union[str, list]]:
        """
        Start the process.
        
        Args:
            task (Optional[WaveTask], optional): The task to perform. Defaults to None.
        
        Returns:
            A dictionary containing the resulting text ("text") and segment-level details ("segments"), and the spoken language ("language"), which is detected when decode_options["language"] is None.
        """
        # Check if the task is None. If it is, set it to the class task.
        if task is None:
            task = self.task
        
        # update the status
        self.__update_status(f"Starting the transcription process. the task is `{task.value}`")
        # Update the status progress
        self.__update_step_status(WordWaveStep.transcribe, ProcessState.in_progress)
        # Start the transcription process
        result = self.model.transcribe(
            audio       = self.audio_file_path,      # The audio file path
            language    = self.language_code,        # The language code
            fp16        = torch.cuda.is_available(), # The fp16 flag
            task        = task.value,              # The task
            verbose     = self.verbose
        )
        if task == WaveTask.translate:
            # Change the language code to 'en'
            self.language_code = 'en'
        return result
    
    def __transcribe(self) -> None:
        """
        Start the transcription process.
        
        Args:
            None
        
        Returns:
            None
        """
        try:
            if self.task == WaveTask.defualt:
                # Start the processing.
                __result = self.__start_process(
                    task    = WaveTask.transcribe if self.language_code == 'en' else WaveTask.translate
                )
            else:
                __result = self.__start_process()
            
            # Save the result
            self.__save_result(__result)
            
            # Update the status
            self.__update_status(f"Transcription completed.")
            # Update the status progress
            self.__update_step_status(WordWaveStep.transcribe, ProcessState.completed)
        except Exception as e:
            # Upate the status
            self.__update_status(f"Error transcribing the audio: {e}")
            # Update the status progress
            self.__update_step_status(WordWaveStep.transcribe, ProcessState.failed)
            logger.error(f"Error transcribing the audio: {e}")
            raise Exception(f"Error transcribing the audio: {e}")
    
    def __save_result(self, result: Dict[str, Union[str, list]]) -> None:
        """
        Save the result to a file.
        
        Args:
            result (Dict[str, Union[str, list]]): The result.
        
        Returns:
            None
        """
        # Save the result to an file
        writer = get_writer('all', self.output_dir)
        writer(result, self.audio_file_path, self.word_options)
        # supported_formats.
        self.supported_formats = ["txt","vtt","srt","tsv","json"]
        
        # Set the paths
        self.__data: List[dict] = []
        for ext in self.supported_formats:
            file_name: str   = FileManager.get_file_name_form_path(self.audio_file_path)
            output_file: str = f'{self.output_dir}/{FileManager.get_just_file_name(file_name)}.{ext}'
            self.__data.append({
                'type': ext,
                'path': FileManager.normalize_path(output_file.replace(ProjectPaths.project_root, '.')),
            })

    def __concat_srt_with_video(self) -> None:
        """
        Concatenate the SRT file with the original video.
        
        Args:
            None
        
        Returns:
            None
        """
        
        try:
            # Update the status
            self.__update_status(f"Concatenating the SRT file with the original video.")
            # Update the status progress
            self.__update_step_status(WordWaveStep.concat_srt, ProcessState.in_progress)
            srt_file = [d for d in self.__data if d['type'] == 'srt' ][0]['path']
            # Concatenate the SRT file with the original video
            self.output_file = concat_srt_with_video(
                video_file_path = ProjectPaths.project_root + self.media.file_path, # The video file path
                srt_file        = srt_file,
                output_file     = f'{self.output_dir}/output_transcribe_{self.language_code}.mp4',       # The output file path
            )
            # Update the status
            self.__update_status(f"Concatenation completed.")
            # Update the status progress
            self.__update_step_status(WordWaveStep.concat_srt, ProcessState.completed)
        except Exception as e:
            # Update the status
            self.__update_status(f"Error concatenating the SRT file with the original video: {e}")
            # Update the status progress
            self.__update_step_status(WordWaveStep.concat_srt, ProcessState.failed)
            logger.error(f"Error concatenating the SRT file with the original video: {e}")      
    
    def run(self) -> None:
        """
        Run the WordWave process.
        
        Args:
            None
            
        Returns:
            None
        """
        try:
            # Initialize the attributes
            self.__initailize_attributes()
            
            # Detect the language of the audio if the language code is not specified or 'auto'
            self.__detect_language()
            # Run the WordWave process
            self.__transcribe()
            
            if (self.concat_srt):
                # Concatenate the SRT file with the original video
                self.__concat_srt_with_video()
            else:
                # Set the output file to the orginal video file path
                self.output_file = self.media.file_path
                # Update the status
                self.__update_status(f"Concatenation skipped.")
                # Update the status progress
                self.__update_step_status(WordWaveStep.concat_srt, ProcessState.skipped)
            
            data: Dict[str, any] = {
                'data'             : self.__data,
                "language_code"    : self.language_code,
            }
            
            ai_process: AIProcess = AIProcessController().create(
                media_uid   = self.media.uid,
                model_name  = self.model_name,
                model_key   = self.model_key,
                data        = data,
                task        = self.task.value,
            )
            
            # Add the uid of the AIProcess to the data dictionary
            data["process_uid"] = ai_process.uid
            
            # Update the status
            self.__update_status(
                state         = 'completed',
                state_message = f"WordWave process completed.",
                state_details = data
            )
            # Update the status progress
            self.__update_step_status(WordWaveStep.completed, ProcessState.completed)
            # Delete the temporary audio file.
            # Note: Remove the audio file after completing the process.
            self.__delete_audio_file()
        except Exception as e:
            # Delete the temporary audio file.
            self.__delete_audio_file()
            # Update the status
            self.__update_status(f"Error running the WordWave process: {e}")
            # Update the status progress
            self.__update_step_status(WordWaveStep.completed, ProcessState.failed)
            raise
            
    @staticmethod
    def handle_data(data: dict) -> dict:
        """
        Handle the data before sending it to the client.
        
        Note: The structure of the data is as follows:
            {
                "data": [
                    {
                        "type": "txt",
                        "path": "path/to/file.txt"
                    },
                    {
                        "type": "vtt",
                        "path": "path/to/file.vtt"
                    },
                    {
                        "type": "srt",
                        "path": "path/to/file.srt"
                    },
                    {
                        "type": "tsv",
                        "path": "path/to/file.tsv"
                    },
                    {
                        "type": "json",
                        "path": "path/to/file.json"
                    }
                ],
                "language_code": "en"
            }
        
        Args:
            data (dict): The data.
            
        Returns:
            dict: The handled data.
        """
        try:
            # Get the data
            temp: List[dict] = data['data']
            for item in temp:
                # Get the content
                content     = FileManager.read_content(file_path= item['path'])
                # Add the content to the item
                item['content'] = content
            # Update the data
            data['data'] = temp
            return data
        except Exception as e:
            raise Exception(f"Error handling the data: {e}") from e
    