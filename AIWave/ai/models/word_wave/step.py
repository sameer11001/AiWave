from enum import Enum

class WordWaveStep(Enum):
    initialize      = '[1] Initializing the WordWave process'
    detect_language = '[2] Detecting the language of the audio'
    transcribe      = '[3] Transcribing the audio'
    concat_srt      = '[4] Concatenating the SRT file with the original video'
    completed       = '[5] WordWave process completed'
