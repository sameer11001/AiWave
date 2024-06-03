""" Built-in modules """
from typing import Any, Dict, List

""" Local modules """
from logs import CustomLogger
from utils import WaveResponse as r
from utils import Validator, FileManager
from ._helper import get_file_paths_from_ai_processes, get_file_paths_from_ai_process
from flask_app.endpoints.users import users_blueprint
from database.local_db.models import (
    User,
    Media,
    AIProcess,
    DeleteMedia,
    GetUserData,
    AIProcessController,
)
from errors import (
    WaveException,
    UserNotFoundException,
    UserException,
    InvalidOptionException,
    MediaNotFoundException,
)


logger = CustomLogger('users_routes [<user_uid>]')

@users_blueprint.route('/<user_uid>', methods=['GET'])
def get_user(user_uid: str):
    """
    Get a user from the database.
    """
    try:        
        # Get the user from the database.
        user: User = GetUserData().get_user_by_uid(user_uid)
        
        if user is None:
            raise UserNotFoundException()
        
        logger.info(f'Successfully retrieved user with uid `{user_uid}`.')
        return r.success(message='Successfully retrieved user.', user=user.to_map())
    except UserNotFoundException as e:
        logger.error(e, code=e.code)
        return r.error(error=f'User with uid `{user_uid}` not found.', code=e.code, status_code=404)
    except WaveException as e:
        return r.error(message='Failed to retrieve all users.', error=e, code=e.code)
    except Exception as e:
        return r.error(message='Failed to retrieve all users.', error=e)
        # TODO: Add abort(403) if the user is not an admin.


@users_blueprint.route('/<user_uid>/<attribute>', methods=['GET'])
def get_user_attribute(user_uid: str, attribute: str):
    """
    Get a user attribute from the database.
    """
    try:
        # Get the user from the database.
        user: User = GetUserData().get_user_by_uid(user_uid)
        
        if user is None:
            raise UserNotFoundException()

        user_map: Dict[str, Any] = user.to_map(show_media=True)
        
        # Remove the uid from the user map.
        user_map.pop('uid', None)
        
        if attribute not in user_map:
            raise InvalidOptionException(f'Attribute `{attribute}` not found.')
        
        return r.success(message='Successfully retrieved user attribute.', data=user_map[attribute])
    except InvalidOptionException as e:
        attributets=list(user_map.keys())
        
        logger.error(e, code=e.code)
        return r.error(
            error=e,
            attributets=attributets,
            code=e.code,
            status_code=404
        )
    except UserNotFoundException as e:
        logger.error(e, code=e.code)
        return r.error(error=f'User with uid `{user_uid}` not found.', code=e.code, status_code=404)
    except WaveException as e:
        logger.error(e, code=e.code)
        return r.error(message='Failed to retrieve the user.', error=e, code=e.code)
    except Exception as e:
        logger.error(e)
        return r.error(message='Failed to retrieve the user.', error=e)


#########| Media

@users_blueprint.route('/<user_uid>/media/<media_uid>', methods=['GET'])
def get_media_by_uid(user_uid: str, media_uid):
    """
    Get a media by uid.
    """
    try:
        # Validate the request.
        user: User = GetUserData().get_user_by_uid(user_uid)
        
        if user is None:
            raise UserNotFoundException()
        
        # Validate the media_uid if it exists return the media object else return error
        media: Media = Validator.is_media_exist(media_uid)
        
        if media is None:
            raise MediaNotFoundException()
        
        if media.user_uid != user.uid:
            raise UserException(message="You are not allowed to use this media", code="not_allowed")
        
        return r.success(message='Successfully retrieved media.', data=media.to_map())
    except WaveException as e:
        logger.error(e, code=e.code)
        return r.error(message='Failed to retrieve the media.', error=e, code=e.code)
    except Exception as e:
        logger.error(e)
        return r.error(message='Failed to retrieve the media.', error=e)

@users_blueprint.route('/<user_uid>/media/<media_uid>/delete', methods=['DELETE'])
def delete_media_by_uid(user_uid: str, media_uid):
    """
    Delete a media by uid.
    """
    try:
        # Validate the request.
        user: User = GetUserData().get_user_by_uid(user_uid)
        
        if user is None:
            raise UserNotFoundException()
        
        # Validate the media_uid if it exists return the media object else return error
        media: Media = Validator.is_media_exist(media_uid)
        
        if media is None:
            raise MediaNotFoundException()
        
        if media.user_uid != user.uid:
            raise UserException(message="You are not allowed to use this media", code="not_allowed")
        
        # Get the file paths from the ai processes.
        file_paths: List[str] = get_file_paths_from_ai_processes(media.ai_process)
        # Add the media file path.
        file_paths.append(media.file_path)
        
        # Delete the media.
        DeleteMedia(
            media_uid=media.uid,
        ).delete()
        
        # Delete the files.
        for file_path in file_paths:
            FileManager.delete_file(file_path, remove_dir_if_empty=True)
        
        return r.success(message='Successfully deleted media.')
    except WaveException as e:
        logger.error(e, code=e.code)
        return r.error(message='Failed to delete the media.', error=e, code=e.code)
    except Exception as e:
        logger.error(e)
        return r.error(message='Failed to delete the media.', error=e)

#########| AI Processes

@users_blueprint.route('/<user_uid>/media/<media_uid>/ai_processes', methods=['GET'])
def get_ai_processes_by_media_uid(user_uid: str, media_uid):
    """
    Get a media by uid.
    """
    try:
        # Validate the request.
        user: User = GetUserData().get_user_by_uid(user_uid)
        
        if user is None:
            raise UserNotFoundException()
        
        # Validate the media_uid if it exists return the media object else return error
        media: Media = Validator.is_media_exist(media_uid)
        
        if media is None:
            raise MediaNotFoundException()
        
        if media.user_uid != user.uid:
            raise UserException(message="You are not allowed to use this media", code="not_allowed")
        
        ai_process: List[AIProcess] = media.ai_process
        
        return r.success(message='Successfully retrieved media.', data=[process.to_map() for process in ai_process])
    except WaveException as e:
        logger.error(e, code=e.code)
        return r.error(message='Failed to retrieve the media.', error=e, code=e.code)
    except Exception as e:
        logger.error(e)
        return r.error(message='Failed to retrieve the media.', error=e)

@users_blueprint.route('/<user_uid>/media/<media_uid>/ai_processes/<ai_process_uid>', methods=['GET'])
def get_ai_process_by_uid(user_uid: str, media_uid, ai_process_uid):
    """
    Get a media by uid.
    """
    try:
        # Validate the request.
        user: User = GetUserData().get_user_by_uid(user_uid)
        
        if user is None:
            raise UserNotFoundException()
        
        # Validate the media_uid if it exists return the media object else return error
        media: Media = Validator.is_media_exist(media_uid)
        
        if media is None:
            raise MediaNotFoundException()
        
        if media.user_uid != user.uid:
            raise UserException(message="You are not allowed to use this media", code="not_allowed")
        
        ai_process: AIProcess = AIProcessController().get(ai_process_uid)
        
        if ai_process is None:
            raise UserException(message="AI Process not found", code="not_found")
        
        return r.success(message='Successfully retrieved media.', data=ai_process.to_map())
    except WaveException as e:
        logger.error(e, code=e.code)
        return r.error(message='Failed to retrieve the media.', error=e, code=e.code)
    except Exception as e:
        logger.error(e)
        return r.error(message='Failed to retrieve the media.', error=e)

@users_blueprint.route('/<user_uid>/media/<media_uid>/ai_processes/<ai_process_uid>/delete', methods=['DELETE'])
def delete_ai_process_by_uid(user_uid: str, media_uid, ai_process_uid):
    """
    Delete a media by uid.
    """
    try:
        # Validate the request.
        user: User = GetUserData().get_user_by_uid(user_uid)
        
        if user is None:
            raise UserNotFoundException()
        
        # Validate the media_uid if it exists return the media object else return error
        media: Media = Validator.is_media_exist(media_uid)
        
        if media is None:
            raise MediaNotFoundException()
        
        if media.user_uid != user.uid:
            raise UserException(message="You are not allowed to use this media", code="not_allowed")
        
        ai_process: AIProcess = AIProcessController().get(ai_process_uid)
        
        if ai_process is None:
            raise UserException(message="AI Process not found", code="not_found")
        
        # Get the file paths from the ai process.
        file_paths: List[str] = get_file_paths_from_ai_process(ai_process.to_map())
        
        # Delete the ai process.
        AIProcessController().delete(ai_process_uid)
        
        # Delete the files.
        for file_path in file_paths:
            FileManager.delete_file(file_path, remove_dir_if_empty=True)
        
        return r.success(message='Successfully deleted media.')
    except WaveException as e:
        logger.error(e, code=e.code)
        return r.error(message='Failed to delete the media.', error=e, code=e.code)
    except Exception as e:
        logger.error(e)
        return r.error(message='Failed to delete the media.', error=e)
