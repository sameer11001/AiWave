""" Built-In Imports """
from typing import Dict, Any,Optional

""" Third-Party Imports """
from langchain.schema.output_parser import StrOutputParser
from langchain.retrievers import ArxivRetriever, WikipediaRetriever
from langchain.schema.runnable import RunnablePassthrough, RunnableSerializable


""" Local Modules """
from ai.llm_base import LLMBase
from ai.prompts import RESEARCH_WAVE_PROMPT
from .researche_source import ResearcheSource
from errors.handlers import MabyeWrongInputException


class ResearcherChatBot(LLMBase):
    """
    ResearcherChatBot is the AI Assistant that is used by the Researcher to answer the user's questions.
    """
    
    # Metadata
    model_name: str = "researcher_chatbot"
    model_key: str  = "rc"
    
    _chain: Optional[Dict[str, Optional[RunnableSerializable[Dict[str, Any], str]]]] = None
    
    @property
    def retriever(self):
        if self.source == ResearcheSource.ARXIV:
            return ArxivRetriever(load_max_docs=6)
        elif self.source == ResearcheSource.WIKI:
            return WikipediaRetriever(lang="en", top_k_results=6)
        else:
            raise ValueError(f"Invalid source: {self.source}")
    
    @property
    def chain(self) -> Optional[RunnableSerializable[Dict[str, Any], str]]:
        """
        Get the chain instance.
        
        Return:
            Optional[RunnableSerializable[Dict[str, Any], str]]: The chain instance.
        """
        if self._chain is None: self._chain = {}
        
        _key: str = self.source.value
        _chain = self._chain.get(_key)
        
        if _chain is None:
                        
            def get_docs(x: Dict[str, Any]) -> Dict[str, Any]:
                question = x["question"]
                ret = self.retriever
                doc_list = ret.get_relevant_documents(question)
                    
                res = {"question": x["question"], "doc": '\n'.join([doc.page_content for doc in doc_list])}
                return res
            
            scrape_and_summarize_chain = RESEARCH_WAVE_PROMPT | self.llm_wise | StrOutputParser()
            
            _chain = RunnablePassthrough.assign(
                docs = get_docs
            ) | scrape_and_summarize_chain

            # Save the chain
            self._chain[_key] = _chain
        
        return _chain

    def __init__(self, source: ResearcheSource = ResearcheSource.ARXIV) -> None:
        """
        Initialize the AI Assistant with the necessary configurations.
        
        Args:
            source (ResearcheSource, optional): The source of the research. default: ResearcheSource.ARXIV
        
        Returns:
            None
        """
        # Initialize the attributes
        self.source = source
        
        # Intialize the base class
        super().__init__()

    def predict(self, user_ask: str) -> Dict[str, Any]:
        """
        Predict the response based on the user's input.

        Args:
            user_ask (str): The user's input/question.

        Returns:
            Dict[str, Any]: The response and conversation history as a dictionary.
        """
        try:
            response = self.chain.invoke({'question': user_ask})

            return {
                "question": user_ask,
                "answer": response
            }
        except IndexError as _:
            raise MabyeWrongInputException()
        except:
            raise
