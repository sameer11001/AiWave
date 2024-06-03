""" Built-in modules """
from typing import Dict, List

""" Third-party modules """
from flask import request

""" Local modules """
from ai import WordWave
from utils import Validator
from utils import WaveResponse as r
from ai.models.word_wave.task import WaveTask
from flask_app.endpoints.word_wave import word_wave_blueprint
from database.local_db.models import Media, Status, User, AIProcess
from errors.handlers import WaveException, UserException, MediaException


from logs import CustomLogger

logger = CustomLogger('word_wave_routes [run]')


@word_wave_blueprint.route('/run', methods=['POST'])
def run():
    """
    The run word_wave endpoint.
    """
    try:
        # Validate the request
        user: User = Validator.validate_user_request(request)
        # Get the data from body
        data: Dict[str, any] = request.get_json()
        # Get the media_id from the data
        media_uid: str = data.get('media_uid')
        # Get the language code from the data
        language_code: str = data.get('language_code')
        # Get the task from the data
        task: WaveTask = WaveTask.from_str(data.get('task'))
        # Validate the media_id if it exists return the media object else return error
        media: Media = Validator.is_media_exist(media_uid)

        # Check if the user is the owner of the media
        if media.user_uid != user.uid:
            raise UserException(message="You are not allowed to use this media", code="not_allowed")

        # Get all the media processed by the user
        user_media_processed: List[AIProcess] = media.ai_process
        # Check if the media is already processed
        for media_processed in user_media_processed:
            if media_processed.model_name == WordWave.model_name and media_processed.task == task.value:
                raise MediaException(message="This media is already processed", code="already_processed")
    
        # Create the word_wave object
        word_wave = WordWave(
            media           = media,
            language_code   = language_code,
            task            = task,
        )
        
        # Get the status of the word_wave
        status: Status = word_wave.get_status()
        # Run the word_wave
        word_wave.start()   
        return r.success(message="Word Wave is running", status=status.to_map())
    except WaveException as e:
        logger.error(e, code=e.code)
        return r.error(error=e, code=e.code)
    except Exception as e:
        logger.error(e)
        return r.error(error=e)
