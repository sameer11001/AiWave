""" Built-in modules """
from typing import Optional

""" Third-party modules """
from langchain.chains import ConversationChain
from langchain.memory import ConversationBufferMemory
from langchain.schema import messages_from_dict, messages_to_dict
from langchain.memory.chat_message_histories.in_memory import ChatMessageHistory


def conversation_memory_to_dict(conversation: ConversationChain) -> dict:
    """
    Convert a conversation memory to a dictionary
    
    args:
        conversation: ConversationChain, the conversation to convert
    
    returns:
        data: dict, the memory converted to a dictionary
    """
    #? retrieve_from_db = json.loads(json.dumps(ingest_to_db))
    
    # Extract the messages from the memory
    messages = conversation.memory.chat_memory.messages
    # # Get the last 3 messages
    # messages = messages[-3:]
    return messages_to_dict(messages)


def conversation_buffer_memory_from_dict(data: dict, ai_prefix: Optional[str] ="Eva") -> ConversationBufferMemory:
    """
    Create a conversation memory from a dictionary
    
    args:
        data (dict): The data to create the memory from
        ai_prefix (str, optional): The AI prefix to use. Defaults to "Eva"
    
    returns:
        memory: ConversationBufferMemory, the memory created from the data
    
    Example:
        >>> data = {'chat_memory': [{'text': 'Hello', 'sender': 'user'}, {'text': 'Hi', 'sender': 'bot'}]}
        >>> memory = tourism_conversation_buffer_memory_from_dict(data)
        >>> memory.chat_memory.messages
        [ChatMessage(sender='user', text='Hello'), ChatMessage(sender='bot', text='Hi')]
    """
    # Extract the messages from the data
    data = data['chat_memory']
    # # Get the last 3 messages
    # data = data[-3:]
    chat_memory = ChatMessageHistory(messages=messages_from_dict(data))
    return ConversationBufferMemory(
        chat_memory = chat_memory,
        ai_prefix   = str(ai_prefix).upper(),
    )
