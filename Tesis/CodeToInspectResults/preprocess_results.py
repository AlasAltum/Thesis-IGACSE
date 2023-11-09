"""
Script intended to extract and transform data from the results, so they can be graphed and
added into a excel file.
Form URL: https://forms.gle/6JXo8FmPmmarP2AA6


The questions that matter for the evaluation are:
1, 5, 6, 7, 14, 15, 16, 17, 18, 19, 20, 21, 
22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35


i1*: The game design is attractive (interface, graphics, boards, cards, etc.)
i2: The text font and colors are well blended and consistent.
i3: I needed to learn a few things before I could play the game.
i4: Learning to play this game was easy for me.
i5*: I think that most people would learn to play this game very quickly.
i6*: I think that the game is easy to play.
i7*: The game rules are clear and easy to understand.
i8: The fonts (size and style) used in the game are easy to read.
i9: The colors used in the game are meaningful.
i10: The contents and structure helped me to become confident that I would learn with this game.
i11: This game is appropriately challenging for me.
i12: The game provides new challenges (offers new obstacles, situations or variations) at an appropriate pace.
i13: The game does not become monotonous as it progresses (repetitive or boring tasks).
i14*: Completing the game tasks gave me a satisfying feeling of accomplishment.
i15*: It is due to my personal effort that I managed to advance in the game.
i16*: I feel satisfied with the things that I learned from the game.
i17*: I would recommend this game to my colleagues.
i18: I was able to interact with other players during the game. # <= This question is part of the original questionaire, but it was not in our questionaire
i19: The game promotes cooperation and/or competition among the players. # <= This question is part of the original questionaire, but it was not in our questionaire
i20: I felt good interacting with other players during the game. # <= This question is part of the original questionaire, but it was not in our questionaire
i21*: I had fun with the game.
i22*: Something happened during the game (game elements, competition, etc.) which made me smile.
i23*: There was something interesting at the beginning of the game that captured my attention.
i24*: I was so involved in my gaming task that I lost track of time.
i25*: I forgot about my immediate surroundings while playing this game.
i26*: The game contents are relevant to my interests.
i27*: It is clear to me how the contents of the game are related to the course.
i28*: This game is an adequate teaching method for this course.
i29*: I prefer learning with this game to learning through other ways (e.g. other teaching methods).
i30*: The game contributed to my learning in this course.
i31*: The game allowed for efficient learning compared with other activities in the course.

Questions in spanish:
i1*: El diseño de juego es atractivo
i2: La fuente de texto y los colores están bien combinados y son consistentes
i3: Tuve que aprender cosas antes de poder jugar
i4: Aprender a jugar se me hizo fácil 
i5*: Creo que la mayoría de la gente aprendería a usar este juego rápidamente.
i6*: Creo que el juego es fácil de jugar.
i7*: Las reglas del juego son claras y fáciles de entender
i8: Las fuentes (su tamaño y estilo) usadas son fáciles de leer
i9: Los colores usados en el juego son significativos
i10: La estructura me ayudó a tener confianza en que aprendería con este juego
i11: Este juego es desafiante en la medida justa
i12: El juego ofrece nuevos desafíos a un ritmo adecuado
(i13 manual): El juego no se vuelve monótomo a medida que se avanza
(i13 en paper): Cuando vi el juego por primera vez, tuve la sensación de que sería fácil para mí
i14*: Completar las tareas del juego me provocó satisfacción
i15*: Pude avanzar en el juego gracias a mi esfuerzo personal
i16*: Siento satisfacción con lo aprendido en este juego
i17*: Recomendaría este juego a mis colegas

*** Social questions are skipped, from i18 to i20.
*** Pude interactuar con otros jugadores mientras jugaba.
*** El juego promueve la cooperación o competencia entre jugadores.
*** Me sentí bien interactuando con otros jugadores durante el juego.

i21*: Me entretuve con el juego
i22*: Algún elemento del juego me hizo sonreír
i23*: Había algo interesante al inicio del juego que llamó mi atención
i24*: Estaba tan envuelt@ en la tarea propuesta por el juego que perdí la noción del tiempo
i25*: Me olvidé de mi entorno físico mientras jugaba
i26*: Los contenidos del juego son relevantes para mis intereses
i27*: Es claro ver que los contenidos del juego se relacionan a cierta materia de la carrera
i28*: Este juego es adecuado para enseñar el contenido
i29*: Prefiero aprender con este juego en vez de aprender con otros métodos de enseñanza
i30*: El juego contribuyó a mi aprendizaje
i31*: El juego me permitió aprender de forma eficiente en comparación con otras actividades

"""

import os
import sys
import re
import csv

import pandas as pd

# Set current working directory as this script's path
script_directory = os.path.dirname(os.path.abspath(sys.argv[0]))
os.chdir(script_directory)
# CSV file that should be in the same folder as this script
ORIGINAL_FILE_NAME = "Evaluación de videojuego educativo IGASCE.csv"

class UserRegister:
    """ User registers come from the .csv files in the google forms in a rather hard to analyze way.
    i.e. {"Marca temporal" : 2023/04/12 12:35:35 a. m. GMT-3,
    "Por favor, contesta las siguientes preguntas [El diseño de juego es atractivo]": "Muy de acuerdo", 
    "Por favor, contesta las siguientes preguntas [La fuente de texto y los colores están bien combinados y son consistentes]": "De acuerdo",
    ...
    So, each key should consider only the part between the square brackets and have its key.
    This class will keep the UserRegister class simple
    """
    _QUESTION_REGEX_PATTERN = r'\[([^\]]+)\]
    _QUESTION_REGEX = re.compile(_QUESTION_REGEX_PATTERN)
    # According to EXTRA.csv given in the MEEGAEvaluation folder. These files were given by Petri et al.
    _MAP_LIKERT_TO_INT = {
        "Muy en desacuerdo": 1,
        "En desacuerdo": 2,
        "Ni en desacuerdo ni de acuerdo": 3,
        "De acuerdo": 4,
        "Muy de acuerdo": 5,
    }

    def __init__(self, answers_as_dict: dict):
        self.questions = []  # Array of strings that consider only the square brackets
        self.answers = []  # Array of ints that consider only map between the likert scale and integers.
        for key, value in answers_as_dict.items():
            if UserRegister._is_question(key):
                self.questions.append(
                    UserRegister._get_question_in_square_brackets(key)
                )
                self.answers.append(
                    UserRegister._likert_scale_to_int(value)
                )

    @staticmethod
    def _likert_scale_to_int(answer: str):
        return UserRegister._MAP_LIKERT_TO_INT[answer]

    @staticmethod
    def _is_question(key: str) -> bool:
        """ Check if the key has a pattern with a question [question]"""
        return bool(re.search(UserRegister._QUESTION_REGEX, key))

    @staticmethod
    def _get_question_in_square_brackets(key: str) -> str:
        return re.search(UserRegister._QUESTION_REGEX, key).groups()[0]

def read_csv(file_path: str):
    ret = []
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            reader = csv.DictReader(file)
            for row in reader:
                # Assuming the Google Form headers are in the first row of the CSV file
                # You can access the columns by their header names, for example: row['Column_Name']
                ret.append(UserRegister(row))

    except FileNotFoundError:
        print("File not found. Please check the file path and try again.")
    except Exception as e:
        print(f"An error occurred: {e}")

    return ret


# First we save every register separated per question in this format
# Register1 = {Q1: value11, Q2: value21, Q3: value31}
# Register2 = {Q1: value12, Q2: value22, Q3: value32}

def main():
    """ Read the user registers and turn it into a CSV where the columns are the questions,
    and the answers are just coma-separated values from 1 to 5.
    """
    results_csv = read_csv(ORIGINAL_FILE_NAME)
    # We want to create a dataframe like this:
    # Person index |  Q1  |  Q2  |  Q3  | ...   
    #      1       |  2   |  -1  |  0   | ...
    #      2       |  1   |  -1  |  2   | ...
    #      3       |  -2  |  -2  |  1   | ...

    columns = results_csv[0].questions
    dict_df = {key : [] for key in columns}

    for row in results_csv:
        questions = row.questions # columns
        answers = row.answers #
        for question, answer in zip(questions, answers):
            dict_df[question].append(answer)

    output_df = pd.DataFrame(dict_df)
    # The form_csv file will contain the questions and answers in a friendly way
    form_csv = "ProcessedAnswersFromGoogleForms.csv"
    # But we also need an EXTRA.csv format with the questions in the format:
    # ID;i01;i02;i03,...,i35
    # 1; 4; 4;...
    # 2; 3; 5;...
    # So we will create that file too

    

    output_df.to_csv(form_csv, index=False)


if __name__ == "__main__":
    main()