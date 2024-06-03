""" Built-in modules """
from typing import List, Optional

""" Third-party modules """
import numpy as np
from ultralytics.engine.results import Boxes

""" Local modules """
from utils.serializer import (
    json_serializer,
    json_deserializer
)

class VisionBox:
    def __init__(self, label:str, confidence: float, coordinates: tuple, track_id: Optional[int] = None) -> None:
        """
        Initialize the VisionBox object.
        
        Args:
            label (str): Label of the detected object.
            confidence (float): Confidence of the detected object.
            coordinates (tuple): Coordinates of the detected object. in the format (x, y, x, y).
            track_id (Optional[int]): The track ID of the detected object.
        
        Returns:
            None
        """
        self.label: str = label
        self.confidence: float = confidence
        self.coordinates: tuple = coordinates
        self.track_id: Optional[int] = track_id
    
    def __repr__(self) -> str:
        """
        String representation of the VisionBox object.
        
        Args:
            None
        
        Returns:
            String representation of the VisionBox object.
        """
        return f"VisionBox(track_id={self.track_id}, confidence={self.confidence}, coordinates={self.coordinates})"   
    
    def to_dict(self) -> dict:
        """
        Convert the VisionBox object to a dictionary.
        
        Args:
            None
        
        Returns:
            dict: A dictionary representation of the VisionBox object.
        """
        return {
            "track_id": self.track_id,
            "confidence": self.confidence,
            "coordinates": str(self.coordinates)
        }
    
    @classmethod
    def from_dict(cls, vision_box: dict) -> 'VisionBox':
        """
        Convert a dictionary to a VisionBox object.
        
        Args:
            vision_box (dict): A dictionary representation of the VisionBox object.
        
        Returns:
            VisionBox: A VisionBox object.
        """
        return cls(
            label=vision_box["label"],
            confidence=vision_box["confidence"],
            coordinates=vision_box["coordinates"],
            track_id=vision_box.get("track_id", None)
        )

    def to_json(self) -> str:
        """
        Convert the VisionBox object to a JSON string.
        
        Args:
            None
        
        Returns:
            str: A JSON string representation of the VisionBox object.
        """
        return json_serializer(self.to_dict())

    @classmethod
    def from_json(cls, vision_box: str) -> 'VisionBox':
        """
        Convert a JSON string to a VisionBox object.
        
        Args:
            vision_box (str): A JSON string representation of the VisionBox object.
        
        Returns:
            VisionBox: A VisionBox object.
        
        Example:
            >>> VisionBox.from_json('{"track_id": None, "confidence": 0.0, "coordinates": {"x": 0, "y": 0, "w": 0, "h": 0}}')
            <__main__.VisionBox object at 0x7f9b7c1b5b80>
        """
        return cls.from_string(json_deserializer(vision_box))

class VisionResults:
    def __init__(self, frame: np.ndarray, annotated_frame: np.ndarray, vision_boxes: List[VisionBox], yolo_box: Boxes, source_id:Optional[int] = None, timestamp: Optional[str] = None) -> None:
        """
        Initialize the VisionResults object.
        
        Args:
            source_id (int): The source ID of the frame.
            frame (np.ndarray): The frame.
            annotated_frame (np.ndarray): The annotated frame.
            vision_boxes (List[VisionBox]): A list of VisionBox objects.
            yolo_box (Boxes): The Boxes object.
            timestamp (Optional[str]): The timestamp of the frame for the sorted results.
        
        Returns:
            None
        
        Example:
            >>> VisionResults(0, [VisionBox])
            <__main__.VisionResults object at 0x7f9b7c1b5b80>
        """
        self.source_id: Optional[int] = source_id
        self.frame: np.ndarray  = frame
        self.annotated_frame: np.ndarray = annotated_frame
        self.vision_boxes: List[VisionBox] = vision_boxes
        self.yolo_box: Boxes = yolo_box
        
        self.timestamp: str = timestamp
    
    def __repr__(self) -> str:
        """
        String representation of the VisionResults object.
        
        Args:
            None
        
        Returns:
            String representation of the VisionResults object.
        
        Example:
            >>> VisionResults(0, [VisionBox])
            "VisionResults(frame=0, vision_boxes=[VisionBox])"
        """
        return f"VisionResults(frame={self.frame}, annotated_frame= {self.annotated_frame},vision_boxes={self.vision_boxes}), yolo_box={self.yolo_box}"

class VisionTrackerResults:
    def __init__(self, frame: np.ndarray, vision_boxes: List[VisionBox]) -> None:
        """
        Initialize the VisionTrackerResults object.
        
        Args:
            frame (np.ndarray): The frame.
            vision_boxes (List[VisionBox]): A list of VisionBox objects.
        
        Returns:
            None
        
        Example:
            >>> VisionTrackerResults(frame, [VisionBox])
            <__main__.VisionTrackerResults object at 0x7f9b7c1b5b80>
        """
        self.frame      = frame
        self.vision_boxes  = vision_boxes
    
    def __repr__(self) -> str:
        """
        String representation of the VisionTrackerResults object.
        
        Args:
            None
        
        Returns:
            String representation of the VisionTrackerResults object.
        
        Example:
            >>> VisionTrackerResults(frame, [VisionBox])
            "VisionTrackerResults(frame=0, vision_boxes=[VisionBox])"
        """
        return f"VisionTrackerResults(frame={self.frame}, vision_boxes={self.vision_boxes})"
