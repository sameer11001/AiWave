""" Built-In Imports """
import ast
from typing import Dict, Any, Optional

""" Third-Party Imports """
from langchain.schema.output_parser import StrOutputParser
from langchain.retrievers import ArxivRetriever, WikipediaRetriever
from langchain.schema.runnable import RunnablePassthrough, RunnableSerializable

""" Local Modules """
from ai.llm_base import LLMBase
from .researche_source import ResearcheSource
from errors.handlers import MabyeWrongInputException
from ai.prompts import SUMMARY_PROMPT, SEARCH_PROMPT, RESEARCH_PROMPT


class ResearcherChatBotBeta(LLMBase):
    """
    ResearcherChatBotBeta is the AI Assistant that is used by the Researcher to answer the user's questions.
    """
    
    # Metadata
    model_name: str = "researcher_chatbot_beta"
    model_key: str  = "rc-b"
    
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
            ret = self.retriever
            
            scrape_and_summarize_chain = RunnablePassthrough.assign(
                summary =  SUMMARY_PROMPT | self.llm_wise | StrOutputParser()
            ) | (lambda x: f"Title: {x['doc'].metadata.get('Title')}\n\nSUMMARY: {x['summary']}")

            web_search_chain = RunnablePassthrough.assign(
                docs = lambda x: ret.get_relevant_documents(x["question"])
            )| (lambda x: [{"question": x["question"], "doc": u} for u in x["docs"]]) | scrape_and_summarize_chain.map()

            search_question_chain = SEARCH_PROMPT | self.llm_wise | StrOutputParser()

            full_research_chain = search_question_chain | self.__handle_queries_search | web_search_chain.map()

            _chain = RunnablePassthrough.assign(
                research_summary= full_research_chain | self.__collapse_list_of_lists
            ) | RESEARCH_PROMPT | self.llm_wise | StrOutputParser()

            # Save the chain
            self._chain[_key] = _chain

        return _chain

    def __init__(self, source: ResearcheSource = ResearcheSource.ARXIV) -> None:
        """
        Initialize the AI Assistant with the necessary configurations.
        
        Args:
            source (ResearcheSource, optional): The source of the research. Defaults to ResearcheSource.ARXIV.
        
        Returns:
            None
        """
        # Initialize the attributes
        self.source = source
        
        # Initialize the LLMBase
        super().__init__()
    
    def __handle_queries_search(self, search_string):
        # Extracting search queries from the given string
        queries_start_index = search_string.find('```python') + len('```python\n')
        queries_end_index = search_string.find('\n```', queries_start_index)
        queries_text = search_string[queries_start_index:queries_end_index].strip()

        # Parsing the variable assignment using ast.literal_eval
        try:
            parsed_ast = ast.parse(queries_text)
            queries_list = ast.literal_eval(parsed_ast.body[0].value)
        except (SyntaxError, ValueError):
            # Handle parsing errors
            queries_list = []

        return [{"question": q} for q in queries_list]

    def __collapse_list_of_lists(self, list_of_lists):
        content = []
        for l in list_of_lists:
            content.append("\n\n".join(l))
        return "\n\n".join(content)

    def predict(self, user_ask: str) -> Dict[str, Any]:
        """
        Predict the response based on the user's input.

        Args:
            user_ask (str): The user's input/question.

        Returns:
            Dict[str, Any]: The response and conversation history as a dictionary.
        """
        try:
            response = self.chain.invoke({
                'question': user_ask
            })

            return {
                "question": user_ask,
                "answer": response,
            }
        except IndexError as _:
            raise MabyeWrongInputException()
        except:
            raise
