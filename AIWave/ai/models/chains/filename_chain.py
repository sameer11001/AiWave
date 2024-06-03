""" Built-in modules """
from typing import Any, Dict

""" Third-party modules """
from langchain.schema.output_parser import StrOutputParser
from langchain.schema.runnable import RunnableSerializable

""" Local modules """
from ai.llm_base import LLMBase
from ai.prompts import FILE_NAME_PROMPT

class FileNameChain(LLMBase):
    """
    FileNameChain is the AI Assistant that is used to generate a file name.
    """
    
    _chain:  RunnableSerializable[Dict[str, Any], str] = None
    
    @property
    def chain(self) -> RunnableSerializable[Dict[str, Any], str]:
        """
        Get the chain instance.
        
        Return:
            Optional[RunnableSerializable[Dict[str, Any], str]]: The chain instance.
        """
        # Check if the chain is not initialized. Then initialize it.
        if self._chain is None:
            self._chain = FILE_NAME_PROMPT | self.llm | StrOutputParser()

        return self._chain

    def __init__(self) -> None:
        """
        Initialize the AI Assistant with the necessary configurations.
        
        Args:
            None
        
        Returns:
            None
        """
        # Initialize the LLMBase
        super().__init__()
    
    def run_from_file(self, md_file_path: str):
        """
        Run the AI Assistant.
        
        Args:
            file_type (str): The file type.
            file_contents (str): The file contents.
        
        Returns:
            None
        """
        with open(md_file_path, "r") as f:
            md_file_contents = f.read()
        
        return self.run(md_file_contents)
    
    def run(self, md_file_contents: str):
        """
        Run the AI Assistant.
        
        Args:
            md_file_contents (str): The file contents.
        
        Returns:
            None
        """
        return self.chain.invoke({
            "file_contents": md_file_contents,
        })
