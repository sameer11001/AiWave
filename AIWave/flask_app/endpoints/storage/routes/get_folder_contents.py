""" Built-in modules """
import os

""" Third-party modules """
from flask import send_from_directory

""" Local modules """
from logs import CustomLogger
from utils import WaveResponse as r
from utils.project_paths import ProjectPaths
from flask_app.endpoints.storage import storage_blueprint


logger = CustomLogger('storage_routes [get_folder_contents]')


@storage_blueprint.route('/folders/', methods=['GET'])
@storage_blueprint.route('/folders/<path:folder_path>', methods=['GET'])
def get_folder_contents(folder_path: str = None):
    """
    Get the contents (folders and files) of the specified folder path or serve a file if it exists.
    """
    try:
        if folder_path is None:
            folder_path = "./"
            
        MAIN_DIR = ProjectPaths.frontend_dir
        # Check if the route is being accessed from the backend
        if folder_path.__contains__('storage/backend'):
            MAIN_DIR = ProjectPaths.backend_dir
            # Remove the 'storage/backend' part of the path
            folder_path = folder_path.replace('storage/backend/', '')
            
        full_path = f"{MAIN_DIR}/{folder_path}"

        if os.path.exists(full_path):
            if os.path.isdir(full_path):
                folders = [{'folder': f} for f in os.listdir(full_path) if os.path.isdir(os.path.join(full_path, f))]
                files   = [{'file': f} for f in os.listdir(full_path) if os.path.isfile(os.path.join(full_path, f))]
                folders_and_files: list = folders + files
                return r.success(
                    message='Successfully served the folder contents.',
                    folder_path=folder_path,
                    contents=folders_and_files
                )
            elif os.path.isfile(full_path):
                # Serve the file
                return send_from_directory(MAIN_DIR, folder_path)
            else:
                return r.error('The specified path is not a valid directory or file.')
        else:
            return r.error('The specified path does not exist.')
    except Exception as e:
        logger.error(e)
        return r.error(error=str(e))
