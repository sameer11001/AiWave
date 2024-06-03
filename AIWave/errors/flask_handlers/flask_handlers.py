""" Third-party modules """
from flask import Flask, render_template

def init_errors_routes(app: Flask) -> None:
    """
    Initialize the error routes.

    Args:
        app (Flask): The Flask application instance.
    
    Returns:
        None
    """
    # Custom 404 error handler
    @app.errorhandler(404)
    def not_found_error(error):
        return render_template('errors/404.html'), 404

    # Generic error handler for other errors
    @app.errorhandler(Exception)
    def internal_error(error):
        # You can log the error here for debugging purposes
        return render_template('errors/500.html'), 500
