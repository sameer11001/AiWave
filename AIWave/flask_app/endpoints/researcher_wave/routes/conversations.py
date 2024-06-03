""" Built-in modules """
from typing import List

""" Third-party modules """
from flask import request

""" Local modules """
from utils import Validator
from logs import CustomLogger
from ai import ResearcherChatBot
from utils import WaveResponse as r
from database.local_db.models import Conversation, User
from errors.handlers import WaveException, ConversationNotFoundException
from flask_app.endpoints.researcher_wave import researcher_wave_blueprint


logger = CustomLogger('researcher_wave_routes [conversations]')

@researcher_wave_blueprint.route('/conversations', methods=['GET'])
def conversations():
    """
    The conversations endpoint.
    """
    try:
        # Validate the request
        user: User = Validator.validate_user_request(request)
        
        conversations: List[Conversation] = user.conversations
        
        data = [conversation.uid for conversation in conversations if conversation.uid.__contains__(ResearcherChatBot.model_key)]
        
        return r.success(message='The conversations were retrieved successfully.', data=data)
    # Handle the required value exception
    except WaveException as e:
        logger.error(e)
        return r.error(error=e, code=e.code)
    except Exception as e:
        logger.error(e)
        return r.error(error=e)
    
@researcher_wave_blueprint.route('/conversations/<conversation_uid>', methods=['GET'])
def conversation(conversation_uid: str):
    """
    The conversation endpoint.
    """
    try:
        # Validate the request
        user: User = Validator.validate_user_request(request)
        
        conversation: Conversation = user.get_conversation(
            conversation_uid    = conversation_uid,
            prefix              = ResearcherChatBot.model_key
        )
        
        if conversation is None:
            raise ConversationNotFoundException()
        
        data = conversation.to_map()
        
        return r.success(message='The conversation was retrieved successfully.', data=data)
    # Handle the required value exception
    except WaveException as e:
        logger.error(e)
        return r.error(error=e, code=e.code)
    except Exception as e:
        logger.error(e)
        return r.error(error=e)
