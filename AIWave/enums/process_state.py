from enum import Enum

class ProcessState(Enum):
    pending     = 'pending'
    in_progress = 'in_progress'
    completed   = 'completed'
    failed      = 'failed'
    partial     = 'partial'
    skipped     = 'skipped'
