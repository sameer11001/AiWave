""" Built-in modules """
import os
from threading import Thread
from typing import Dict, List

""" Third-party modules """
from translate import Translator


""" Local modules """
from logs import CustomLogger
from utils import supported_languages

logger = CustomLogger("TranslateSrt")

class TranslateSrt(Thread):
    """
    Class for translating an SRT file into multiple languages and saving the translations.
    """

    def __init__(self, input_srt_path: str, output_folder: str = 'translated_srt', languages: List[str] = ['ar', 'fr']) -> None:
        """
        Initialize the TranslateSrt class with supported languages.

        Args:
            input_srt_path (str): Path to the input SRT file.
            output_folder (str , optional): Folder where translated files will be saved. Defaults to 'translated_srt'.
            languages (List[str], optional): List of language codes to translate to. Defaults to ['ar', 'fr'].
        
        Returns:
            None
        """
        # Initialize the Thread class.
        super().__init__()
        
        self.input_srt_path: str        = input_srt_path
        self.output_folder: str         = output_folder
        self.languages: Dict[str, str]  = self._get_supported_languages(languages)
        
        # Create the output folder if it doesn't exist.
        os.makedirs(output_folder, exist_ok=True)

    def _get_supported_languages(self, languages: List[str]) -> Dict[str, str]:
        """
        Get the supported languages.

        Args:
            languages (List[str]): List of language codes to translate to.

        Returns:
            Dict[str, str]: Dictionary of supported languages.
        """
        languages_dict = {}
        
        # Loop through the languages and check if they are supported.
        for lang_code in languages:
            # Check if the language code is supported.
            if lang_code in list(supported_languages.keys()):
                # Add the language code and name to the supported languages dictionary.
                languages_dict[lang_code] = supported_languages[lang_code]
            else:
                print(f'Language code {lang_code} not supported.')

        return languages_dict

    def _translate_subtitle(self, lang_code: str, lines: list) -> List[str]:
        """
        Translate the subtitles into the specified language.

        Args:
            lang_code (str): The language code to translate to.
            lines (list): List of subtitle lines to be translated.

        Returns:
            List[str]: List of translated subtitle lines.
        """
        try:
            translator = Translator(to_lang=lang_code)
            translated_lines = []

            for line in lines:
                line = line.strip()
                if line.isdigit():
                    # This is the subtitle number, keep it as is.
                    translated_lines.append(line)
                elif '-->' in line:
                    # This is the timing information, keep it as is.
                    translated_lines.append(line)
                else:
                    # Translate the subtitle text.
                    try:
                        translation = translator.translate(line)
                        translated_lines.append(translation)
                    except Exception as e:
                        logger.error(f"Error translating to {self.languages[lang_code]}: {str(e)}")

            return translated_lines
        except Exception as e:
            logger.error(f"Error translating to {self.languages[lang_code]}: {str(e)}")
            raise Exception(f"Error translating to {self.languages[lang_code]}: {str(e)}")

    def _save_translation(self, lang_code: str, translated_lines: list) -> None:
        """
        Save the translated subtitles to a file.

        Args:
            lang_code (str): The language code.
            translated_lines (list): Translated subtitle lines.

        Returns:
            None.
        """
        try:
            output_path = os.path.join(self.output_folder, f"{lang_code}.srt")

            with open(output_path, 'w', encoding='utf-8') as output_file:
                output_file.write('\n'.join(translated_lines))

            print(f'Translation to {self.languages[lang_code]} saved at: {output_path}')
        except Exception as e:
            print(f"Error saving translation to {self.languages[lang_code]}: {str(e)}")
            raise Exception(f"Error saving translation to {self.languages[lang_code]}: {str(e)}")

    def translate_and_save_srt(self) -> None:
        """
        Translate the input SRT file into multiple languages and save the translations.

        Args:
            None.
        
        Returns:
            None.
        """

        with open(self.input_srt_path, 'r', encoding='utf-8') as f:
            lines = f.readlines()

        threads = []

        for lang_code, lang_name in self.languages.items():
            translated_lines = self._translate_subtitle(lang_code, lines)
            self._save_translation(lang_code, translated_lines)

    def run(self) -> None:
        """
        Thread run method.
        
        Args:
            None.
        
        Returns:
            None.
        """
        try:
            # Translate the input SRT file.
            self.translate_and_save_srt()
        except Exception as e:
            logger.error(f"Error translating SRT file: {str(e)}")


# # Example usage:
# if __name__ == "__main__":
#     # Translate the input SRT file.
#   
#     # Set the input SRT file.
#     input_srt_file = 'storage/backend/x/videos/word_wave/en/subtitle_en.srt'
#     # Set the output folder.
#     output_folder = 'translated_srt'
#    
#     # Create the TranslateSrt object.
#     translator = TranslateSrt(input_srt_file)
#    
#     # Start the translation.
#     translator.start()
# 
#     # Wait for the translation to finish.
#     translator.join()
# 
#     print('Translation complete.')
