""" Built-in modules """
from typing import Dict, Optional

""" Third-party modules """
from flask import request, url_for

""" Local modules """
from utils import Validator
from logs import CustomLogger
from utils import WaveResponse as r
from database.local_db.models import User
from errors.handlers import RequiredValueException, WaveException
from ai.models.researcher_wave.researche_source import ResearcheSource
from flask_app.endpoints.researcher_wave import researcher_wave_blueprint
from ai import ResearcherChatBot, ResearcherChatBotBeta, ResearcherChatBotAlpha


logger = CustomLogger('researcher_wave_routes [chatbot]')


@researcher_wave_blueprint.route('/chatbot', methods=['POST'])
def run():
    """
    The Researcher assistant chatbot endpoint.
    """
    try:
        # Validate the request
        user: User = Validator.validate_user_request(request)
        # Get the data from body
        data: Dict[str, any] = request.get_json()
        
        # Get the user_ask from the data
        prompt: str = data.get('prompt')
        # Get the source from the data
        source_key: str = data.get('source')
        # Check if the prompt is None
        if not prompt:
            raise RequiredValueException(message='`prompt` is required')

        # Create an instance of the AIAssistant
        ai_assistant = ResearcherChatBot(
            source = ResearcheSource.from_str(source_key) if source_key else ResearcheSource.ARXIV
        )
        # Run the AIAssistant
        output = ai_assistant.predict(prompt)

        return r.success(message='Researcher Wave run successfully', output = output)
    # Handle the required value exception
    except WaveException as e:
        logger.error(e)
        return r.error(error=e, code=e.code)
    except Exception as e:
        logger.error(e)
        return r.error(error=e)

@researcher_wave_blueprint.route('/chatbot-beta', methods=['POST'])
@researcher_wave_blueprint.route('/chatbot_beta', methods=['POST'])
def run_beta():
    """
    The Researcher assistant chatbot endpoint.
    """
    try:
        # Validate the request
        user: User = Validator.validate_user_request(request)
        # Get the data from body
        data: Dict[str, any] = request.get_json()
        
        # Get the user_ask from the data
        prompt: str = data.get('prompt')
        # Get the source from the data
        source_key: str = data.get('source')
        # Check if the prompt is None
        if not prompt:
            raise RequiredValueException(message='`prompt` is required')

        # Create an instance of the AIAssistant
        ai_assistant = ResearcherChatBotBeta(
            source = ResearcheSource.from_str(source_key) if source_key else ResearcheSource.ARXIV
        )
        # Run the AIAssistant
        output = ai_assistant.predict(prompt)

        return r.success(message='Researcher Wave [beta] run successfully', output = output)
    # Handle the required value exception
    except WaveException as e:
        logger.error(e)
        return r.error(error=e, code=e.code)
    except Exception as e:
        logger.error(e)
        
@researcher_wave_blueprint.route('/chatbot-alpha', methods=['POST'])
@researcher_wave_blueprint.route('/chatbot_alpha', methods=['POST'])
def run_alpha():
    """
    The Researcher assistant chatbot endpoint.
    """
    try:
        # Validate the request
        user: User = Validator.validate_user_request(request)
        # Get the data from body
        data: Dict[str, any] = request.get_json()
        
        # Get the user_ask from the data
        prompt: str = data.get('prompt')
        # Get the source from the data
        source_key: str = data.get('source')
        # Check if the prompt is None
        if not prompt:
            raise RequiredValueException(message='`prompt` is required')

        # Create an instance of the AIAssistant
        ai_assistant = ResearcherChatBotAlpha(
            source = ResearcheSource.from_str(source_key) if source_key else ResearcheSource.ARXIV
        )
        # Run the AIAssistant
        output = ai_assistant.predict(prompt)

        from utils import save_to_md_file
        
        filename: Optional[str] = None
        try:
            from ai import chains
        
            filename = chains.FileNameChain().run(
                md_file_contents    = output['answer']
            )
        except Exception as e:
            pass
        
        md_file_path:str = save_to_md_file(
            user_uid    = user.uid,
            content     = output['answer'],
            file_name   = filename + '.md' if filename else None,
        )
        
        # Generate the file url
        md_file_url:str = url_for('storage_blueprint.serve_file', filename=md_file_path, _external=True)

        # Add the file to the response
        output['md_file_name'] = filename
        output['md_file_url']  = md_file_url

        return r.success(message='Researcher Wave [alpha] run successfully', output = output)
    # Handle the required value exception
    except WaveException as e:
        logger.error(e)
        return r.error(error=e, code=e.code)
    except Exception as e:
        logger.error(e)
