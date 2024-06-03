""" Built-in modules """

""" Third-party modules """
from flask import request

""" Local modules """
from utils import Validator
from utils import WaveResponse as r
from errors.handlers import WaveException
from database.local_db.models import Status
from flask_app.endpoints.vision_wave import vision_wave_blueprint


from logs import CustomLogger

logger = CustomLogger('vision_wave_routes [status]')

@vision_wave_blueprint.route('/status/<status_uid>', methods=['GET'])
def status(status_uid):
    """
    The status vision_wave endpoint.
    """
    try:
        # Validate the request
        user = Validator.validate_user_request(request)
        # Get the status from the database
        status: Status = Validator.is_status_exist(status_uid)
        
        return r.success(message="Status is retrieved", status=status.to_map())
    except WaveException as e:
        logger.error(e, code=e.code)
        return r.error(error=e, code=e.code)
    except Exception as e:
        logger.error(e)
        return r.error(error=e)
