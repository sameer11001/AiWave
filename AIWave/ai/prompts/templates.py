""" Third-party modules """
from langchain.prompts import PromptTemplate


__RESEARCH_WAVE_TEMPLATE = """{docs} 

-----------
Your name is 'Researcher Wave' and you are a professional researcher. 
Using the above text, answer in short the following question: 

> {question}

-----------
if the question cannot be answered using the text say "I'm sorry, I don't know that.".
write the answer in 'apa' format.
Please do your best, this is very important to my career."""

RESEARCH_WAVE_PROMPT = PromptTemplate.from_template(__RESEARCH_WAVE_TEMPLATE)

###################| Beta |###################

__RESEARCH_REPORT_TEMPLATE = """{doc} 

-----------

Using the above text, answer in short the following question: 

> {question}

-----------
if the question cannot be answered using the text, imply summarize the text. Include all factual information, numbers, stats etc if available."""

SUMMARY_PROMPT = PromptTemplate.from_template(__RESEARCH_REPORT_TEMPLATE)

__SEARCH_PROMPT_TEMPLATE = """Write 3 google search queries to search online that form an objective opinion from the following: {question}
You must respond with a list of strings in the following format in python. Please do your best, this is very important to my career.
Format: 'q = ["query 1", "query 2", "query 3"];'
"""

SEARCH_PROMPT = PromptTemplate.from_template(__SEARCH_PROMPT_TEMPLATE)


__SEARCH_PROMPT_TEMPLATE_ALPHA = """Write 3 google search queries to search online that form an objective opinion from the following: {question}
You must respond with a list of strings in the following format. Please do your best, this is very important to my career.
Format: ["query 1", "query 2", "query 3"]
"""

SEARCH_PROMPT_ALPHA = PromptTemplate.from_template(__SEARCH_PROMPT_TEMPLATE_ALPHA)


__RESEARCH_PROMPT_TEMPLATE = """Information:
--------
{research_summary}
--------
Using the above information, answer the following question or topic: "{question}" in a detailed report -- \
The report should focus on the answer to the question, should be well structured, informative, \
in depth, with facts and numbers if available and a minimum of 1,200 words.
You should strive to write the report as long as you can using all relevant and necessary information provided.
You must write the report with markdown syntax.
You MUST determine your own concrete and valid opinion based on the given information. Do NOT deter to general and meaningless conclusions.
Write all used source urls at the end of the report, and make sure to not add duplicated sources, but only one reference for each.
You must write the report in apa format.
Please do your best, this is very important to my career."""


RESEARCH_PROMPT = PromptTemplate.from_template(__RESEARCH_PROMPT_TEMPLATE)

###################| Utils |###################

__FILE_NAME_PROMPT_TEMPLATE = """You are a professional file name writer. You have been hired to write a file name for a new file. The file is a markdown file. Below is the file's contents based on the contents of the file. Write a professional and creative file name for the file.
the file's contents. return jsut the file name without file extension. do not include the file path. the filename format should be a vaild to save into file system. do not include any special characte. between the word use underscore. do not include any space. do not include any number.
the name should be in lower case.
------------------
{file_contents}
------------------
"""

FILE_NAME_PROMPT = PromptTemplate.from_template(__FILE_NAME_PROMPT_TEMPLATE)
