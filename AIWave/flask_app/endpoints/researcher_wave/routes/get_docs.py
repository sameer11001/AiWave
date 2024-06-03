""" Built-in modules """
import os
from typing import List

""" Third-party modules """
from flask import request, url_for

""" Local modules """
from utils import Validator
from enums import FileType
from logs import CustomLogger
from utils import WaveResponse as r
from database.local_db.models import User
from errors.handlers import WaveException
from utils.file_manager import FileManager
from utils.project_paths import ProjectPaths
from flask_app.endpoints.researcher_wave import researcher_wave_blueprint


logger = CustomLogger('researcher_wave_routes [get_docs]')


@researcher_wave_blueprint.route('/docs', methods=['GET'])
def get_docs():
    """
    Get the docs endpoint.
    """
    try:
        # Validate the request
        user: User = Validator.validate_user_request(request)
        
        # Get the user documents folder
        docs_folder: str = ProjectPaths.user_backend_type_dir(
            user_uid=user.uid,
            backend_type=FileType.DOCUMENT
        )
        
        # Get all the md files in the folder
        docs_path: List[str] = [os.path.join(docs_folder, file) for file in os.listdir(docs_folder) if file.endswith('.md')]
        
        # Create the docs data to store the file name, file url and the content
        docs: List[str] = []
        # Loop through the docs_path
        for d in docs_path:
            # Create the res
            res = {
                'file_name': os.path.basename(d),
                'file_url': url_for(
                    'storage_blueprint.serve_file',
                    filename=d.replace(ProjectPaths.project_root, ''),
                    _external=True
                ),
                'content': FileManager.read_content(d)
            }
            # Append the res to the docs_data
            docs.append(res)

        return r.success(message='The documents were retrieved successfully.', docs=docs)
    # Handle the required value exception
    except WaveException as e:
        logger.error(e)
        return r.error(error=e, code=e.code)
    except Exception as e:
        logger.error(e)
        return r.error(error=e)
