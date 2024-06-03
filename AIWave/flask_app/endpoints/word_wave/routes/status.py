""" Third-party modules """
from flask import request

""" Local modules """
from ai import WordWave
from utils import Validator
from utils import WaveResponse as r
from errors.handlers import WaveException
from database.local_db.models import Status
from flask_app.endpoints.word_wave import word_wave_blueprint


from logs import CustomLogger

logger = CustomLogger('word_wave_routes [status]')

@word_wave_blueprint.route('/status/<status_uid>', methods=['GET'])
def status(status_uid):
    """
    The status word_wave endpoint.
    """
    try:
        # # Validate the request
        # user = Validator.validate_user_request(request)
        # Get the status from the database
        status: Status = Validator.is_status_exist(status_uid)
        
        # Get the content from the query params
        with_content: str = request.args.get('content', default='true')
        
        if status.state_details is not None and with_content != 'false':
            # format the data and add the content to the status_details
            status.state_details = WordWave.handle_data(status.state_details)

        return r.success(message="Status is retrieved", status=status.to_map())
    except WaveException as e:
        logger.error(e, code=e.code)
        return r.error(error=e, code=e.code)
    except Exception as e:
        logger.error(e)
        return r.error(error=e)
