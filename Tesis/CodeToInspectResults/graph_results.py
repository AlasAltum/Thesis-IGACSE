import csv
import os
import sys
import re

"""
Script intended to create graph results analyzing the answers of the users.
Form URL: https://forms.gle/6JXo8FmPmmarP2AA6
"""

class UserRegister:
    """ User registers come from the .csv files in the google forms in a rather hard to analyze way.
    i.e. {"Marca temporal" : <...>,
    "Por favor, contesta las siguientes preguntas [El diseño de juego es atractivo]": "Muy de acuerdo", ...
    So, each key should consider only the part between the square brackets and have its key.
    This class will keep the UserRegister in the simplest way
    """
    _QUESTION_REGEX_PATTERN = r'\[([^\]]+)\]'
    _QUESTION_REGEX = re.compile(_QUESTION_REGEX_PATTERN)


    def __init__(self, answers_as_dict: dict):
        self.questions = []  # Array of strings that consider only the square brackets
        self.answers = []  # Array of ints that consider only map between the likert scale and integers.
        for key, value in answers_as_dict.items():
            if UserRegister._is_question(key):
                self.questions.append(
                    UserRegister._get_question_in_square_brackets(key)
                )
                self.answers.append()

    @staticmethod
    def _is_question(key: str) -> bool:
        """ Check if the key has a pattern with a question [question]"""
        return bool(re.search(UserRegister._QUESTION_REGEX, key))

    @staticmethod
    def _get_question_in_square_brackets(key: str) -> str:
        return re.search(UserRegister._QUESTION_REGEX, key).groups[0]

# Set current working directory as this script's path
script_directory = os.path.dirname(os.path.abspath(sys.argv[0]))
os.chdir(script_directory)
# CSV file that should be in the same folder as this script
ORIGINAL_FILE_NAME = "Evaluación de videojuego educativo IGASCE.csv"
MAP_LIKERT_TO_INT = {
    "Muy en desacuerdo": 1,
    "En desacuerdo": 2,
    "Ni en desacuerdo ni de acuerdo": 3,
    "De acuerdo": 4,
    "Muy de acuerdo": 5,
}

def likert_scale_to_int(answer: str):
    return MAP_LIKERT_TO_INT[answer]

def read_csv(file_path: str):
    ret = []
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            reader = csv.DictReader(file)
            for row in reader:
                # Assuming the Google Form headers are in the first row of the CSV file
                # You can access the columns by their header names, for example: row['Column_Name']
                ret.append(row)

    except FileNotFoundError:
        print("File not found. Please check the file path and try again.")
    except Exception as e:
        print(f"An error occurred: {e}")

    return ret


results_csv = read_csv(ORIGINAL_FILE_NAME)
