""" Third-party modules """
from langchain_google_genai import (
    GoogleGenerativeAI,
    GoogleGenerativeAIEmbeddings
)

class LLMBase:
    """
    The LLMBase class for handling the LLMs.
    """
    
    # Model name
    BASE_MODEL_NAME = "gemini-pro"
    BASE_EMBEDDINGS_NAME = "models/embedding-001"
    
    # show the model thinking.
    VERBOSE = True
    
    # The temperature of the model
    TEMPERATURE = 0.7
    
    llm: GoogleGenerativeAI = GoogleGenerativeAI(
        model       = BASE_MODEL_NAME,
        temperature = TEMPERATURE,
        verbose     = VERBOSE,
    )

    embeddings: GoogleGenerativeAIEmbeddings = GoogleGenerativeAIEmbeddings(
        model  = BASE_EMBEDDINGS_NAME,
    )
    
    # Multi-models
    llm_createvity: GoogleGenerativeAI = GoogleGenerativeAI(
        model       = BASE_MODEL_NAME,
        temperature = .9,
        verbose     = VERBOSE,
    )
    
    llm_wise: GoogleGenerativeAI = GoogleGenerativeAI(
        model       = BASE_MODEL_NAME,
        temperature = 0.0,
        verbose     = VERBOSE,
    )
