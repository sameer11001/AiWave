""" Built-in modules """
from typing import List, Optional

""" Third-party modules """
import torch
import numpy as np
from ultralytics import YOLO

""" Local modules """
from logs import CustomLogger
from .vision_objects import (
    VisionResults,
    VisionBox,
)

logger = CustomLogger("VisionDetection")

class VisionDetection:
    """
    A class for real-time Vision detection using the YOLOv8n model.

    Attributes:
        model (YOLO): The YOLOv8n model for Vision detection.
        class_list (List[str]): List of class names for detection.

    Methods:
        __init__(self, model_path: Optional[str] = None, epochs: Epochs = Epochs.MEDIUM) -> None:
            Initializes the VisionDetection object.

        _process_frame(self, frame) -> np.ndarray:
            Processes a single frame for Vision detection.

        run(self, frame) -> Tuple[np.ndarray, List[Dict[str, Any]]]:
            Detects objects in a single frame and returns object information.
    """

    def __init__(self, model_path: Optional[str] = None, task: Optional[str] = None) -> None:
        """
        Initialize the VisionDetection object.

        Args:
            model_path (str, optional): Path to the YOLO model weights. If not provided, a default path is used.
            task (str, optional): The task to perform. If not provided, the default task is used.

        Raises:
            ValueError: If invalid input parameters are provided.
        """

        self.task = task if task else "detect"
        self.model_path = model_path if model_path else self.get_model_path()
        self.traking = False
        
        # # check if model file is exists
        # if not os.path.isfile(self.model_path):
        #     raise FileNotFoundError(f"Model file not found at {self.model_path}. Please provide a valid model path.")
        
        try:
            self.model: YOLO = self.create_yolo_model()
            self.device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
            self.model.to(self.device)
            self.class_list = self.model.names
        except Exception as e:
            logger.error(f"Error initializing VisionDetection object: {e}")
            raise Exception(f"Error initializing VisionDetection object: {e}")
    
    def get_model_path(self) -> str:
        """
        Get the model path.

        Returns:
            str: The model path.
        """
        if self.task == "detect":
            return "./models/yolov8n.pt"
        elif self.task == "pose":
            return "./models/yolov8n-pose.pt"
        elif self.task == "seg":
            return "./models/yolov8n-seg.pt"
        else:
            raise ValueError(f"Invalid task {self.task}. Please provide a valid task.")
            
    
    def create_yolo_model(self) -> YOLO:
        """
        Create YOLO model for Vision detection.
        
        Returns:
            YOLO: The YOLOv8n model for Vision detection.
        """
        try:
            return YOLO(self.model_path, task=self.task)
        except Exception as e:
            raise RuntimeError(f"Error loading model: {e}")

    def run(self, frame: np.ndarray, filter_classes: Optional[List[int]] = None) -> VisionResults:
        """
        Detect objects in a single frame and return object information.

        Args:
            frame (numpy.ndarray): The input frame to detect objects in.
            filter_classes (List[int], optional): List of classes to filter by. If not provided, all classes are returned.

        Returns:
            VisionResults: A VisionResults object.
        
        Raises:
            Exception: If an error occurs while running Vision detection.
        """
        try:
            results = self.run_batch([frame], filter_classes=filter_classes)

            return results[0]
        except Exception as e:
            logger.error(f"Error running Vision detection: {e}")
            raise Exception(f"Error running Vision detection: {e}")
    
    
    def run_batch(self, frames: List[np.ndarray], filter_classes: Optional[List[int]] = None) -> List[VisionResults]:
        """
        Detect objects in a single frame and return object information.

        Args:
            frame (numpy.ndarray): The input frame to detect objects in.
            filter_classes (List[int], optional): List of classes to filter by. If not provided, all classes are returned.

        Returns:
            List[VisionResults]: List of VisionResults objects.
        
        Raises:
            Exception: If an error occurs while running Vision detection.
        """
        try:
            if self.traking:
                results = self.model.track(frames, conf=0.3, save=False, verbose=False, classes=filter_classes)
            else:
                results = self.model.predict(source=frames, conf=0.3, save=False, verbose=False, classes=filter_classes)
            
            vision_results: List[VisionResults] = []

            for r in results:
                frame            = r.orig_img
                annotated_frame  = r.plot()
                # annotated_frame  = self._process_frame(r.orig_img, r)
                vision_boxes: List[VisionBox] = []

                yolo_box = r.boxes.cpu().numpy()
                for box in yolo_box:
                    # Get the class id
                    class_id = box.cls[0]
                    # Get the class name
                    label = self.class_list[class_id]
                    # Get the confidence
                    conf = box.conf[0]
                    
                    # Get the track id. If no track id is available, set it to None.
                    try:
                        track_id = box.id[0]
                    except:
                        track_id = None
                    # Get the bounding box
                    xyxy = box.xyxy[0]
                    
                    vision_box = VisionBox(
                        label           = label,
                        confidence      = conf,
                        coordinates     = xyxy,
                        track_id        = track_id,
                    )

                    vision_boxes.append(vision_box)
                
                vision_result = VisionResults(
                    frame           = frame,
                    annotated_frame = annotated_frame,
                    vision_boxes       = vision_boxes,
                    yolo_box        = yolo_box,
                )
                
                vision_results.append(vision_result)

            return vision_results
        except Exception as e:
            logger.error(f"Error running Vision detection: {e}")
            raise Exception(f"Error running Vision detection: {e}")
