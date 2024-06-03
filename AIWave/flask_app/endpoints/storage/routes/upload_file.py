""" Built-in modules """
import uuid
from typing import Dict, List

""" Third-party modules """
from flask import request, url_for

""" Local modules """
from logs import CustomLogger
from utils import WaveResponse as r
from utils.project_paths import ProjectPaths
from flask_app.endpoints.storage import storage_blueprint
from utils import secure_filename, FileManager, check_reports

logger = CustomLogger('storage_routes [upload_file]')

@storage_blueprint.route('/upload', methods=['POST'])
def upload():
    try:
        # Check if a files was included in the request
        if 'files' not in request.files:
            return r.error(error='No `files` included in the request.')

        # Get the files from the request
        request_files = request.files.getlist('files')
        # Get the description of files in the request.
        request_files_dir = request.form.get('files_dir')
        print(f'request_files_dir: {request_files_dir}')
        # Create a list to hold the upload report
        files_report: List[Dict[str, str]] = []
        for file in request_files:
            file_name = file.filename
            # Check if the file has a valid filename
            if file_name == '':
                return r.error(error='No file selected.')

            print('file_name: ', file_name)
            is_supported_format = FileManager.is_supported_format(file_name)
            if (is_supported_format):
                file_id = secure_filename(str(uuid.uuid4()))

                upload_dir = ProjectPaths.user_frontend_dir(user_uid=request_files_dir)

                file_ext: str = '.' + FileManager.get_file_extension(file.filename)
                new_file_name: str = file_id + file_ext
                file_path: str = upload_dir + '/' + new_file_name

                file.save(file_path)

                file_path = file_path.replace(ProjectPaths.project_root, '')
                file_url:str = url_for('storage_blueprint.serve_file', filename=file_path, _external=True)

                # Create a new report for the file
                report = {
                    file_name: 'uploaded successfully',
                    'status': 'success',
                    'file_name': file_name,
                    'file_type': file_ext,
                    'file_url': file_url,
                }

            else:
                file_extension = FileManager.get_file_extension(file_name)
                report = {
                    file_name: f'unsupported file format: {file_extension}',
                    'status': 'error',
                }

            files_report.append(report)

        all_has_success_status, all_has_error_status = check_reports(files_report)

        if all_has_error_status:
            # Return an error response
            return r.error(error='No file uploaded successfully.', files=files_report)
        elif all_has_success_status:
            # Return a success response
            return r.success(message= 'Files uploaded successfully.', files=files_report)
        else:
            # Return a partial success response
            return r.partial_success(message= 'Some files uploaded successfully.', files=files_report)
    except Exception as e:
        return r.error(error=e)
