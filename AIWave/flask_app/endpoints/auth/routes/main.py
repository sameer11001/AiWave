""" Third-party modules """
from flask import request, render_template

""" Local modules """
from flask_app.endpoints.auth import auth_blueprint
from logs import CustomLogger
from utils import WaveResponse as r
from utils import convert_readme_to_html


logger = CustomLogger('auth_routes [main]')

@auth_blueprint.route('/', methods=['GET'])
def main():
    """
    The main auth endpoint.
    """
    try:     
        # Get the current URL
        current_url = request.url
        
        # Get the full path to the README.md file
        readme_path = './docs/auth-doc.md'
        
        # Convert the README.md file to HTML
        html_content = convert_readme_to_html(readme_path)
        
        return render_template(
            'documentation/readme_template.html',
            title='Auth Documentation',
            html_content=html_content,  
        )

    except Exception as e:
        logger.error(e)
        return r.error(
            message='Failed to get the current URL.',
            error=e,
            status_code=500
        )
