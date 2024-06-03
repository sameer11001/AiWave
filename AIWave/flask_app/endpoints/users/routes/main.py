""" Built-in modules """

""" Third-party modules """
from flask import render_template

""" Local modules """
from logs import CustomLogger
from utils import WaveResponse as r
from utils import convert_readme_to_html
from flask_app.endpoints.users import users_blueprint


logger = CustomLogger('users_routes [main]')

@users_blueprint.route('/', methods=['GET'])
def main():
    """
    The main users endpoint.
    """
    try:
        # Get the full path to the README.md file
        readme_path = './docs/users-doc.md'

        # Convert the README.md file to HTML
        html_content = convert_readme_to_html(readme_path)
        
        return render_template(
            'documentation/readme_template.html',
            title='Users Documentation',
            html_content=html_content,  
        )
    except Exception as e:
        logger.error(e)
        return r.error(
            message='Failed to get the current URL.',
            error=e,
            status_code=500
        )
