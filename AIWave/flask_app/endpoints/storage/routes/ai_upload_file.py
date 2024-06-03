""" Built-in modules """
import uuid
from typing import Dict, List, Optional

""" Third-party modules """
from flask import request, url_for

""" Local modules """
from enums import FileType
from utils import Validator
from logs import CustomLogger
from utils import WaveResponse as r
from flask_app.endpoints.storage import storage_blueprint
from utils import (
    FileManager,
    ProjectPaths,
    check_reports,
    secure_filename,
    generate_video_thumbnail,
)

from database.local_db.models import (
    User,
    Media,
    AddMedia,
    datetime,
)

logger = CustomLogger('storge_routes [ai_upload]')

@storage_blueprint.route('/ai/upload', methods=['POST'])
def ai_upload():
    try:
        # Check if the request has the required parameters
        user: User = Validator.validate_user_request(request)
        
        # Check if a files was included in the request
        if 'files' not in request.files:
            return r.error(error='No `files` included in the request.')

        # Get the files from the request
        request_files = request.files.getlist('files')
        # Create a list of meida objects
        media_list: List[Media] = []
        # Create a list to hold the upload report
        files_report: List[Dict[str, str]] = []
        for file in request_files:
            file_name = file.filename
            # Check if the file has a valid filename
            if file_name == '':
                return r.error(error='No file selected.')

            is_supported_format = FileManager.is_supported_format(file_name)
            if (is_supported_format):
                file_id = secure_filename(str(uuid.uuid4()))
                file_type: FileType = FileManager.get_file_type(file_name)
                
                upload_dir: str = ProjectPaths.user_backend_type_dir(
                    user_uid         = secure_filename(user.uid),
                    backend_type    = file_type,
                )
                                
                file_ext: str = '.' + FileManager.get_file_extension(file.filename)
                new_file_name: str = file_id + file_ext
                file_path: str = upload_dir + '/' + new_file_name
                
                # desc = request.args.get('desc', None)
                
                file.save(file_path)
                
                file_path = file_path.replace(ProjectPaths.project_root, '')
                # Generate the file url
                file_url:str = url_for('storage_blueprint.serve_file', filename=file_path, _external=True)
                
                thumbnail_url: Optional[str] = None
                # Check if the file is a video
                if file_type == FileType.VIDEO:
                    # Generate the thumbnail for the video
                    thumbnail_path = generate_video_thumbnail(file_path)
                    # Check if the thumbnail was generated
                    if thumbnail_path:
                        thumbnail_url  = url_for('storage_blueprint.serve_file', filename=thumbnail_path, _external=True)
                
                logger.info(f'file_url: {file_url}')
                
                # Create a new media record
                media = Media(
                    uid             = file_id,
                    file_name       = file_name,
                    file_type       = file_ext,
                    file_path       = file_path,
                    file_url        = file_url,
                    thumbnail_url   = thumbnail_url,
                    user_uid        = user.uid,
                    created_at      = datetime.now(),
                )
                           
                # Create a new report for the file
                report = {
                    file_name: 'uploaded successfully',
                    'status': 'success',
                    'media': media.to_map(),
                }
                
                # Add the media to the media list.
                media_list.append(media)
                
            else:
                file_extension:str = FileManager.get_file_extension(file_name)
                report = {
                    file_name: f'unsupported file format: {file_extension}',
                    'status': 'error',
                }
            
            files_report.append(report)
            
        # Add the media to the database
        add_media = AddMedia(user_uid=user.uid)
        add_media.add_all(media_list)
        
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
