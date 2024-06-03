""" Built-in modules """
from typing import Dict, List, Optional


""" Third-party modules """
from flask import request

""" Local modules """
from ai import VisionWave
from utils import Validator
from utils import WaveResponse as r
from ai.models.vision_wave.vision_task import VisionTask
from flask_app.endpoints.vision_wave import vision_wave_blueprint
from database.local_db.models import Media, User, Status, AIProcess
from errors.handlers import WaveException, UserException, MediaException


from logs import CustomLogger

logger = CustomLogger('vision_wave_routes [run]')


@vision_wave_blueprint.route('/run', methods=['POST'])
def run():
    """
    The run vision_wave endpoint.
    """
    try:
        # Validate the request
        user:User = Validator.validate_user_request(request)
        # Get the data from body
        data: Dict[str, any] = request.get_json()
        # Get the media_uid from the data
        media_uid: str = data.get('media_uid')
        # Validate the media_uid if it exists return the media object else return error
        media: Media = Validator.is_media_exist(media_uid)
        # Get the filters if exists
        filters: Optional[List[int]] = data.get('filters', None)
        # Get the traking
        traking: bool = data.get('traking', True)
        # Get the task if exists
        task: Optional[str] = data.get('task', 'detect')
        # Get the hide_objects_count if exists
        hide_objects_count: bool = data.get('hide_objects_count', False)
        if media.user_uid != user.uid:
            raise UserException(message="You are not allowed to use this media", code="not_allowed")
        # Check if the filters is list of int and the int number is between 0 and 79
        if filters is not None:
            if not isinstance(filters, list):
                raise WaveException(message="Filters must be list of int")
            for filter in filters:
                if not isinstance(filter, int):
                    raise WaveException(message="Filters must be list of int")
                if filter < 0 or filter > 79:
                    raise WaveException(message="Filter must be between 0 and 79")
        # Check if the traking is bool
        if not isinstance(traking, bool):
            raise WaveException(message="Traking must be bool")
        
        # Check if the task is valid
        task: VisionTask = VisionTask.from_str(task)

        # Get all the media processed by the user
        user_media_processed: List[AIProcess] = media.ai_process
        # Check if the media is already processed
        for media_processed in user_media_processed:
            if media_processed.model_name == VisionWave.model_name and media_processed.task == task.value:
                raise MediaException(message="This media is already processed", code="already_processed")
        
        # Create the vision_wave object
        vision_wave = VisionWave(
            media   = media,
            filters = filters,
            traking = traking,
            task    = task,
            hide_objects_count = hide_objects_count
        )
        # Get the status of the vision_wave
        status: Status = vision_wave.get_status()
        # Run the vision_wave
        vision_wave.start()   
        return r.success(message="Vision Wave is running", status=status.to_map())
    except WaveException as e:
        logger.error(e, code=e.code)
        return r.error(error=e, code=e.code)
    except Exception as e:
        logger.error(e)
        return r.error(error=e)