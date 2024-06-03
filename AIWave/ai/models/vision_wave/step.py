from enum import Enum

class VisionWaveStep(Enum):
    initialize      = '[1] Initializing the VisionWave process'
    process         = '[2] VisionWave process started'
    completed       = '[3] VisionWave process completed'
