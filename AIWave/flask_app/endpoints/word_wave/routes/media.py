""" Built-in modules """
from typing import List

""" Third-party modules """
from flask import request

""" Local Imports """
from ai import WordWave
from utils import Validator
from logs import CustomLogger
from utils import WaveResponse as r
from flask_app.endpoints.word_wave import word_wave_blueprint
from errors.handlers import WaveException, NotAllowedException, NotFoundException
from database.local_db.models import (
    User,
    Media,
    AIProcess,
    GetMediaData,
    AIProcessController,
)


logger = CustomLogger('word_wave_routes [media]')

@word_wave_blueprint.route('/media', methods=['GET'])
def media():
    """
    The media word_wave endpoint.
    """
    try:
        # Validate the request
        user: User = Validator.validate_user_request(request)
        
        # Initialize the GetMediaData instance
        media_retriever = GetMediaData()
        # Get the media list by model key
        media_list: List[Media] = media_retriever.get_media_by_model_key(WordWave.model_key)
        
        # Get the media list before validation
        len_media_list_before = len(media_list)
        
        # Chack if the media list for this user is alowed to be retrieved
        media_list = Validator.validate_media_list(media_list, user)
        
        # Get the media list after validation
        len_media_list_after = len(media_list)
        
        # Check if the media list is empty
        if len_media_list_after == 0  and len_media_list_before > 0:
            raise NotAllowedException("You are not allowed to retrieve this media")
        
        return r.success(message="Media is retrieved", media_list=[media.to_map() for media in media_list])
    except WaveException as e:
        logger.error(e, code=e.code)
        return r.error(error=e, code=e.code)
    except Exception as e:
        logger.error(e)
        return r.error(error=e)

@word_wave_blueprint.route('/media/<media_uid>', methods=['GET'])
def get_media(media_uid: str):
    """
    The process word_wave endpoint.
    """
    try:
        # Validate the request
        user: User = Validator.validate_user_request(request)
        
        # Initialize the GetMediaData instance
        media_retriever = GetMediaData()
        # Get the media by ID
        media: Media = media_retriever.get_media_by_id(media_uid)
        
        # Check if the media is allowed to be retrieved
        if media.user_uid != user.uid:
            raise NotAllowedException("You are not allowed to retrieve this media")
        
        return r.success(message="media is retrieved", media=media.to_map())
    except WaveException as e:
        logger.error(e, code=e.code)
        return r.error(error=e, code=e.code)
    except Exception as e:
        logger.error(e)
        return r.error(error=e)
    
@word_wave_blueprint.route('/media/<media_uid>/<process_uid>/content', methods=['GET'])
def get_content(media_uid: str, process_uid: str):
    """
    The process word_wave endpoint.
    """
    try:
        # Validate the request
        user: User = Validator.validate_user_request(request)
        
        # Get the content from the query params
        with_content: str = request.args.get('content', default='true')
        
        # Get the process by ID
        process: AIProcess = AIProcessController().get(process_uid)
        
        if process.model_key != WordWave.model_key:
            raise NotFoundException('Process not found')

        # Check if the media uid is the same as the process media uid
        if process.media_uid != media_uid:
            raise WaveException("You are not allowed to retrieve this process")
        
        ai_media = GetMediaData().get_media_by_id(media_uid)
        # Check if the media is allowed to be retrieved
        if ai_media.user_uid != user.uid:
            raise NotAllowedException("You are not allowed to retrieve this media")

        if process.data is not None and with_content != 'false':
            # format the data and add the content to the status_details
            process.data = WordWave.handle_data(process.data)
        
        return r.success(message="Process is retrieved", process=process.to_map())
    except WaveException as e:
        logger.error(e, code=e.code)
        return r.error(error=e, code=e.code)
    except Exception as e:
        logger.error(e)
        return r.error(error=e)
