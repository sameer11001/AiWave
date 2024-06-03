""" Built-in modules """
import os

""" Third-party modules """
from flask import send_from_directory, request

""" Local modules """
from logs import CustomLogger
from utils import WaveResponse as r
from utils.project_paths import ProjectPaths
from errors.handlers import InvalidRequestException
from flask_app.endpoints.storage import storage_blueprint


logger = CustomLogger('storage_routes [serve_file]')

@storage_blueprint.route('/files', methods=['GET'])
def serve_file():
    try:
        UPLOAD_FOLDER = ProjectPaths.project_root
        filename = request.args.get('filename', None)

        if filename is None:
            raise InvalidRequestException(
                message='No `filename` included in the request.',
                code='invalid_request'
            )

        # Construct the absolute file path
        file_path = UPLOAD_FOLDER + filename
        directory = os.path.dirname(file_path)
        path      = os.path.basename(file_path)
        
        logger.debug(f'File path: {file_path}')
        
        # Check if the file exists
        if not os.path.exists(file_path):
            raise FileNotFoundError(f'File not found: {file_path}')

        return send_from_directory(directory, path)
    except Exception as e:
        logger.error(e)
        return r.error(
            message='Failed to serve the file.',
            error=str(e),
        )
