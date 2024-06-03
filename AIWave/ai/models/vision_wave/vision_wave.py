""" Built-in modules """
import os
import uuid
from threading import Thread
from typing import Any, Dict, List, Optional, Tuple

""" Third-party modules """
from tqdm import tqdm
import cv2

""" Database imports """
from database.local_db.models import (
    AIProcessController, 
    AIProcess, 
    AddStatus,
    Media,
    Status,
)

""" Local imports """
from logs import CustomLogger
from .step import VisionWaveStep
from .vision_task import VisionTask
from .vision_objects import VisionResults
from enums.process_state import ProcessState
from .vision_detection import VisionDetection
from enums import FileType
from utils import (
    ProjectPaths,
    FileManager,
    extract_audio,
    concate_audio_with_video,
    format_time,
    extract_unique_object_names,
)

logger = CustomLogger("VisionWave")

class VisionWave(Thread):
    """
    A class for managing Vision detection in a separate thread.
    
    Attributes:
        vision_detection (VisionDetection): The VisionDetection object.
    
    Methods:
        __init__(self, model_path: Optional[str] = None) -> None:
            Initializes the VisionWave object.
    """
    
    # Metadata
    model_name: str = "vision_wave"
    model_key: str  = "vw"
    
    model_det: Optional[VisionDetection]  = None
    model_pose: Optional[VisionDetection] = None
    model_seg: Optional[VisionDetection]  = None
    

    def __init__(self, media: Media, filters: Optional[List[int]] = None, traking: bool = False, task: Optional[VisionTask] = VisionTask.detect, hide_objects_count: bool = False) -> None:
        """
        Initialize the VisionWave object.
        
        Note: The filters list is a list of integers that represent the filters to be applied.
        numbers between 0 and 79 are valid filters.
        
        Args:
            media_uid (Media): The media object to be processed.
            filters (List[int], optional): The filters to be applied. Defaults to None.
            traking (bool, optional): Whether to apply traking or not. Defaults to False.
            task (Optional[VisionTask], optional): The task to perform. Defaults to VisionTask.detect.
            hide_objects_count (bool, optional): Whether to hide the number of objects or not. Defaults to False.
        
        Returns:
            None
        
        Raises:
            ValueError: If invalid input parameters are provided.
        
        """
        # Intantiate the class variables
        self.media: Media = media
        self.filters: Optional[List[str]] = filters
        self.traking: bool = traking
        self.task: VisionTask = task
        self.hide_objects_count: bool = hide_objects_count
        
        # Initialize the thread
        super().__init__()
        self.daemon = True
        self.name = "VisionWave"
        
        # Create a status record
        self.status: Status = self.create_status()
    
    def __initailize_attributes(self) -> None:
        """
        Initialize the Vision process.
        
        Args:
            None
            
        Returns:
            None
        
        Raises:
            RuntimeError: If there is an error initializing the Vision process.
        """
        # Update the status
        self.__update_status(f"Initalized the Vision process started.")
        # Update the status progress
        self.__update_step_status(VisionWaveStep.initialize, ProcessState.in_progress)
        # Initialize the Vision process
        try:
            # Initialize the model if it doesn't exist
            self.__create_vision_model_if_not_exist()
        except Exception as e:
            # Update the status
            self.__update_status(f"Error initializing the Vision process: {e}")
            # Update the status progress
            self.__update_step_status(VisionWaveStep.initialize, ProcessState.failed)
            # Log the error
            logger.error(f"Error initializing the Vision process: {e}")
            raise RuntimeError(f"Error initializing the Vision process.") from e
        
        # Initialize the audio file path
        try:
            # Create the audio file path variable.
            self.file_path: str = ProjectPaths.project_root + self.media.file_path
            # Get the file type.
            self.file_type: FileType = FileManager.get_file_type(self.media.file_name)
            # Check the file type is video.
            if self.file_type == FileType.VIDEO or self.file_type == FileType.IMAGE:
                pass
            else:
                # Raise an error if the file type is not supported.
                raise ValueError(f"Invalid file type: {self.media.file_type}")
        except Exception as e:
            # Update the status
            self.__update_status(f"Error processing the audio file: {e}")
            # Update the status progress
            self.__update_step_status(VisionWaveStep.initialize, ProcessState.failed)
            # Log the error
            logger.error(f"Error processing the audio file: {e}")
            raise Exception(f"Error processing the audio file.") from e
        
        # Get the directory name
        dirname = os.path.dirname(self.media.file_path)
        # Create the output directory
        self.output_dir: str = ProjectPaths.project_root + os.path.join(dirname, self.model_name, self.media.uid)
        # Create the output directory if it doesn't exist
        os.makedirs(self.output_dir, exist_ok=True)
        # Update the status
        self.__update_status(f"Initalized the Vision process completed.")
        # Update the status progress
        self.__update_step_status(VisionWaveStep.initialize, ProcessState.completed)
    
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
        for step in VisionWaveStep:
            # Add the step to the progress
            prgress[step.value] = ProcessState.pending.value
        
        add_status = AddStatus(
            media_uid     = self.media.uid,
            model_name    = self.model_name,
            state         = 'pending',
            state_message = 'Initialized the Vision process.',
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
        
    def __update_step_status(self, step: VisionWaveStep, state: ProcessState) -> None:
        """
        Update the status record.
        
        Args:
            step (VisionWaveStep): The step.
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
    
    def __create_vision_model_if_not_exist(self) -> VisionDetection:
        """
        Create the vision model if it doesn't exist.
        
        Args:
            None
            
        Returns:
            VisionDetection: The vision model.
        """
        try:
            # Check if the model exists
            if self.model_det is None and self.task == VisionTask.detect:
                # Update the status
                self.__update_status(f"Donwloading the vision wave model.")
                # Create the vision model
                self.model_det = VisionDetection()
                return self.model_det
            elif self.model_pose is None and self.task == VisionTask.pose:
                # Update the status
                self.__update_status(f"Donwloading the vision wave model[pose].")
                # Create the vision model
                self.model_pose = VisionDetection(task=VisionTask.pose.name)
                return self.model_pose
            elif self.model_seg is None and self.task == VisionTask.seg:
                # Update the status
                self.__update_status(f"Donwloading the vision wave model[seg].")
                # Create the vision model
                self.model_seg = VisionDetection(task=VisionTask.seg.name)
                return self.model_seg
            else:
                raise ValueError(f"Invalid task: {self.task}")
        except Exception as e:
            logger.error(f"Error creating the vision wave model: {e}")
            raise RuntimeError(f"Error creating the vision wave model.") from e
    
    @property
    def model(self) -> VisionDetection:
        """
        Get the vision model.
        
        Args:
            None
            
        Returns:
            VisionDetection: The vision model.
        """
        if self.task == VisionTask.detect:
            return self.model_det
        elif self.task == VisionTask.pose:
            return self.model_pose
        elif self.task == VisionTask.seg:
            return self.model_seg
        else:
            raise ValueError(f"Invalid task: {self.task}")
    
    def __process_image(self) -> Tuple[str, Dict[str, Any]]:
        """
        Process the image.
        
        Args:
            None
            
        Returns:
            Tuple[str, Dict[int, Any]]:
                - The output file path.
                - A dictionary of the objects information.
        """
        frame = cv2.imread(self.file_path)
        # Get the detections
        detections: VisionResults = self.model.run(frame, filter_classes=self.filters)
        annotated_frame = detections.annotated_frame
        
        # Get the number of objects
        object_counter = len(detections.vision_boxes)
        
        objects_dict = {}
        for box in detections.vision_boxes:
            object_id = box.track_id
            object_name = box.label
            objects_dict[object_id] = {
                'object_name': object_name,
            }
        
        # Check if the number of objects should be hidden
        if not self.hide_objects_count:
            # Draw the number of objects on the frame. TOP-LEFT
            cv2.putText(annotated_frame, f"Objects: {object_counter}", (10, 30), cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 0, 255), 1)

        uuid_str: str = str(uuid.uuid4().hex)
        output_file: str = self.output_dir + f"/processed_{self.task.name}_{uuid_str}"
        # Save the annotated frame
        cv2.imwrite(output_file, annotated_frame)
        
        # Extract the unique object names
        unique_object_names = extract_unique_object_names(objects_dict.values())
        
        # Objects information
        info: dict = {
            "objects_count": object_counter,
            "object_names": unique_object_names,
            "objects": objects_dict,
        }
        
        return output_file, info
    
    def __process_video(self, with_sound: bool = False) -> Tuple[str, Dict[str, Any]]:
        """
        Process the video.
        
        Args:
            with_sound (bool, optional): Whether to process the video with sound or not. Defaults to False.
        
        Returns:
            Tuple[str, Dict[int, Dict[str, Any]]]: 
                - The output file path.
                - A dictionary of the objects information.
        """
        try:
            if with_sound:
                # Extract the audio from the video file
                audio_file = extract_audio(self.file_path)

            # Start the processing
            cap = cv2.VideoCapture(self.file_path)

            # Check if the video file opened successfully
            if not cap.isOpened():
                print("Error: Could not open video file.")
                raise Exception(f"Error: Could not open video file.")

            # Define the codec and create a VideoWriter object to save the output
            fourcc = cv2.VideoWriter_fourcc(*'mp4v')
            uuid_str: str = str(uuid.uuid4().hex)
            output_filename = self.output_dir + f"/processed_{self.task.name}_{uuid_str}_withoutsound.mp4"
            out = cv2.VideoWriter(output_filename, fourcc, 30, (int(cap.get(3)), int(cap.get(4))))

            # Get the total number of frames
            total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))

            objects_dict = {}
            object_counter = 0

            with tqdm(total=total_frames, unit="frames", desc="Processing video") as pbar:
                while True:
                    ret, frame = cap.read()
                    if not ret:
                        break  # End of the video

                    # Start the processing
                    detections = self.model.run(frame, filter_classes=self.filters)

                    # Get the processed frame
                    annotated_frame = detections.annotated_frame
                    # Get the number of objects
                    objects_len = len(detections.vision_boxes)

                    # Check if the number of objects should be hidden
                    if not self.hide_objects_count:
                        # Draw the number of objects on the frame. TOP-LEFT
                        cv2.putText(annotated_frame, f"Objects: {objects_len}", (10, 30),
                                    cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 0, 255), 1)

                    # Write the processed frame to the output video
                    out.write(annotated_frame)
                    
                    # Get the frame timestamp
                    frame_timestamp = cap.get(cv2.CAP_PROP_POS_MSEC) / 1000.0

                    # Update object information
                    for box in detections.vision_boxes:
                        # Check if the object has a track id
                        if box.track_id is None: continue
                        # Convert the track id to integer
                        object_id = int(box.track_id)
                        # Extract the object name
                        object_name = box.label

                        if object_id not in objects_dict:
                            objects_dict[object_id] = {
                                'object_name': object_name,
                                'first_detect_time': format_time(frame_timestamp),
                                'last_detect_time': format_time(frame_timestamp)
                            }
                            object_counter += 1
                        else:
                            objects_dict[object_id]['last_detect_time'] = format_time(frame_timestamp)

                    pbar.update(1)  # Update the progress bar

            # Release the video objects
            cap.release()
            out.release()

            if with_sound:
                # Concatenate the audio and video files
                output_filename = concate_audio_with_video(output_filename, audio_file)
                # Remove the audio file
                FileManager.delete_file(audio_file)
            
            # Extract the unique object names
            unique_object_names = extract_unique_object_names(objects_dict.values())

            # Objects information
            info: dict = {
                "objects_count": object_counter,
                "object_names": unique_object_names,
                "objects": objects_dict,
            }

            return output_filename, info

        except Exception as e:
            if with_sound:
                # Delete the audio file if it exists.
                FileManager.delete_file(audio_file)
            raise e
    
    def start_processing(self) -> str:
        """
        Start processing the media.
        
        Args:
            None
            
        Returns:
            str: The output file path.
        """
        try:
            # Update the status
            self.__update_status(f"Start processing the file.")
            # Update the status progress
            self.__update_step_status(VisionWaveStep.process, ProcessState.in_progress)
            
            self.model.traking = self.traking
            # Check if the source is image
            if(self.file_type == FileType.IMAGE):
                return self.__process_image()
            elif self.file_type == FileType.VIDEO:
                return self.__process_video()
            else:
                raise ValueError(f"Invalid file type: {self.file_type}")  
        except Exception as e:
            # Update the status
            self.__update_status(f"Error processing the file: {e}")
            # Update the status progress
            self.__update_step_status(VisionWaveStep.process, ProcessState.failed)
            # Log the error
            logger.error(f"Error processing the file: {e}")
            raise Exception(f"Error processing the file: {e}")
    
    def run(self) -> None:
        """
        Run the VisionWave process.
        
        Args:
            None
        
        Returns:
            None
        """
        try:
            # Initialize the attributes
            self.__initailize_attributes()
            
            try:
                # Start processing the media
                output_file, objects_info = self.start_processing()
                output_file: str = FileManager.normalize_path(output_file.replace(ProjectPaths.project_root, '.'))
                # Update the status progress
                self.__update_step_status(VisionWaveStep.process, ProcessState.completed)
            except:
                raise
            
            data: Dict[str, Any] = {
                    "output_file": {
                        "path": output_file,
                    },
                    "filters": self.filters,
                    "traking": self.traking,
                    "objects_info": objects_info,
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
                state           = "completed",
                state_message   = f"Completed running the VisionWave process.",
                state_details   = data,
            )
            # Update the status progress
            self.__update_step_status(VisionWaveStep.completed, ProcessState.completed)
        except Exception as e:
            # Update the status
            self.__update_status(f"Error running the WordWave process: {e}")
            # Update the status progress
            self.__update_step_status(VisionWaveStep.completed, ProcessState.failed)
            raise
