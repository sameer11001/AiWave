""" Third-party modules """
from flask import abort, render_template
from flask_app.endpoints.admin import admin_blueprint

""" Local modules """
from logs import CustomLogger
from utils import convert_readme_to_html

logger = CustomLogger('admin_routes [main]')


@admin_blueprint.route('/', methods=['GET'])
def main():
    """
    Main admin endpoint.
    """
    try:
        # Get the full path to the README.md file
        readme_path = './docs/admin-doc.md'
        
        # Convert the README.md file to HTML
        html_content = convert_readme_to_html(readme_path)
        
        return render_template(
            'documentation/readme_template.html',
            title='Admin Documentation',
            html_content=html_content,  
        ) 
    except Exception as e:
        logger.error(e)
        return abort(403)
