""" Built-in modules """
from typing import Any

""" Third-party modules """
from flask import Response, jsonify, make_response

class WaveResponse:
    @classmethod
    def error(cls, error: Any, status_code: int = 400, **kwargs) -> Response:
        """
        Returns a custom error response.
        
        Args:
            error (Any): The error message.
            status_code (int): The status code.
            **kwargs: Additional keyword arguments.
        
        Returns:
            Response: The custom error response.
            
        Examples:
            >>> CustomResponse.error_response("Error message", 400)
            <Response 400>
        """
        data = {
            'status': status_code,
            'error': str(error)
        }
        if kwargs:
            data.update(kwargs)

        return make_response(jsonify(data), status_code)

    @classmethod
    def success(cls, status_code: int= 200,  **kwargs) -> Response:
        """
        Returns a custom success response.
        
        Args:
            status_code (int): The status code.
            **kwargs: Additional keyword arguments.
            
        Returns:
            Response: The custom success response.
            
        Examples:
            >>> CustomResponse.success_response(200)
            <Response 200>
        """
        data = {
            'status': status_code,
        }
        if kwargs:
            data.update(kwargs)
            
        return make_response(jsonify(data), status_code)
    
    @staticmethod
    def partial_success(status_code: int= 206,  **kwargs) -> Response:
        """
        Returns a custom partial success response.
        
        Args:
            status_code (int): The status code.
            **kwargs: Additional keyword arguments.
            
        Returns:
            Response: The custom partial success response.
            
        Examples:
            >>> CustomResponse.partial_success_response(206)
            <Response 206>
        """
        data = {
            'status': status_code,
        }
        if kwargs:
            data.update(kwargs)
            
        return make_response(jsonify(data), status_code)
