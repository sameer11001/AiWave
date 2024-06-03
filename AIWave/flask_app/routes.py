""" Third-party modules """
from flask import Flask, jsonify

""" Local modules """
from utils import ServerInfoChecker


def init_app_route(app: Flask):
    """ 
    Initialize the app routes.
    """
    @app.route('/', methods=['GET'])
    def index():
        python_version = ServerInfoChecker.get_python_version()
        cuda_version = ServerInfoChecker.get_cuda_version()
        gpu_model = ServerInfoChecker.get_gpu_model()
        # Return a response to the client is the server is running
        return jsonify({
            'message': 'Flask server is running',
            'system_info': {
                'python_version': python_version,
                'cuda_version': cuda_version,
                'gpu_model': gpu_model,
            },
        })
