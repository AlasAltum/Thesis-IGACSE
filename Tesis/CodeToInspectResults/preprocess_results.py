"""
Script intended to extract and transform data from the results, so they can be graphed and
added into a excel file.
Form URL: https://forms.gle/6JXo8FmPmmarP2AA6


The questions that matter for the evaluation are (Petri et al. 2018):
[1, 2, 6, 7, 8, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35]

Questions used for THIS evaluation are:
[1, 2, 7, 8, 15, 16, 17, 18, 19, 20, 21, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35]

===============================================
Questions in manual: 
===============================================
i1*: The game design is attractive (interface, graphics, cards, boards, etc.)
i2*: The text font and colors are well blended and consistent
i3: I needed to learn a few things before I could play the game
i4: Learning to play this game was easy for me
i5: I think that most people would learn to play this game very quickly
i6*: I think that the game is easy to play
i7*: The game rules are clear and easy to understand
i8*: The fonts (size and style) used in the game are easy to read
i9: The colors used in the game are meaningful
i10: The game allows customizing the appearance (font and/or color) according to my preferences
i11: The game prevents me from making mistakes
i12: When I make a mistake, it is easy to recover from it quickly
i13: When I first looked at the game, I had the impression that it would be easy for me
i14: The contents and structure helped me to become confident that I would learn with this game
i15*: This game is appropriately challenging for me
i16*: The game provides new challenges (offers new obstacles, situations, or variations) at an appropriate pace
i17*: The game does not become monotonous as it progresses (repetitive or boring tasks)
i18*: Completing the game tasks gave me a satisfying feeling of accomplishment
i19*: It is due to my personal effort that I managed to advance in the game
i20*: I feel satisfied with the things that I learned from the game
i21*: I would recommend this game to my colleagues
i22*: I was able to interact with other players during the game
i23*: The game promotes cooperation and/or competition among the players
i24*: I felt good interacting with other players during the game
i25*: I had fun with the game
i26*: Something happened during the game (game elements, competition, etc.) which made me smile
i27*: There was something interesting at the beginning of the game that captured my attention
i28*: I was so involved in my gaming task that I lost track of time
i29*: I forgot about my immediate surroundings while playing this game
i30*: The game contents are relevant to my interests
i31*: It is clear to me how the contents of the game are related to the course
i32*: This game is an adequate teaching method for this course
i33*: I prefer learning with this game to learning through other ways (e.g., other teaching methods)
i34*: The game contributed to my learning in this course
i35*: The game allowed for efficient learning compared with other activities in the course

===============================================
Questions in spanish (moved indices to manual):
===============================================
i1*: El diseño de juego es atractivo
i2*: La fuente de texto y los colores están bien combinados y son consistentes
i3: Tuve que aprender cosas antes de poder jugar
i4: Aprender a jugar se me hizo fácil
i5: Creo que la mayoría de la gente aprendería a usar este juego rápidamente.
i6*: Creo que el juego es fácil de jugar.
i7*: Las reglas del juego son claras y fáciles de entender
i8*: Las fuentes (su tamaño y estilo) usadas son fáciles de leer
i9: Los colores usados en el juego son significativos
____ (preguntas de customización)
i13: Cuando vi el juego por primera vez, tuve la sensación de que sería fácil para mí
i14*: La estructura me ayudó a tener confianza en que aprendería con este juego
i15*: Este juego es desafiante en la medida justa
i16*: El juego ofrece nuevos desafíos a un ritmo adecuado
i17*: (i13 manual): El juego no se vuelve monótomo a medida que se avanza
i18*: Completar las tareas del juego me provocó satisfacción
i19*: Pude avanzar en el juego gracias a mi esfuerzo personal
i20*: Siento satisfacción con lo aprendido en este juego
i21*: Recomendaría este juego a mis colegas
====
i22*: I was able to interact with other players during the game
i23*: The game promotes cooperation and/or competition among the players
i24*: I felt good interacting with other players during the game
*** Social questions are skipped, from i18 to i20.
*** Pude interactuar con otros jugadores mientras jugaba.
*** El juego promueve la cooperación o competencia entre jugadores.
*** Me sentí bien interactuando con otros jugadores durante el juego.
=====
i25*: Me entretuve con el juego
i26*: Algún elemento del juego me hizo sonreír
i27*: Había algo interesante al inicio del juego que llamó mi atención
i28*: Estaba tan envuelt@ en la tarea propuesta por el juego que perdí la noción del tiempo
i29*: Me olvidé de mi entorno físico mientras jugaba
i30*: Los contenidos del juego son relevantes para mis intereses
i31*: Es claro ver que los contenidos del juego se relacionan a cierta materia de la carrera
i32*: Este juego es adecuado para enseñar el contenido
i33*: Prefiero aprender con este juego en vez de aprender con otros métodos de enseñanza
i34*: El juego contribuyó a mi aprendizaje
i35*: El juego me permitió aprender de forma eficiente en comparación con otras actividades
"""


import os
import sys
import re
import csv

import pandas as pd

# Set current working directory as this script's path
script_directory = os.path.dirname(os.path.abspath(sys.argv[0]))
os.chdir(script_directory)
# TSV file that should be in the same folder as this script. We use tabs
# instead of commas because the questions and answers have many commas.
# Although the values should be between "quotes", this may not work always.
# To get the .tsv file, we need to download it from the forms Google Sheet and
# Save it as a .tsv file
ORIGINAL_FILE_NAME = "Evaluación de videojuego educativo IGACSE.tsv"
MEEGA_PLUS_CSV_ANSWERS_NAME = "EXTRA.csv"
QUESTIONS_THAT_ARE_NOT_FOR_THETA_CALCULATION = [
    'i3', # 'Tuve que aprender cosas antes de poder jugar', # i3
    'i4', # 'Aprender a jugar se me hizo fácil', # i4
    'i8', # 'Las fuentes (su tamaño y estilo) usadas son fáciles de leer', # i8
    'i9', # 'Las reglas del juego son claras y fáciles de entender', # i7
    'i13', # 'Cuando vi el juego por primera vez, tuve la sensación de que sería fácil para mí', # i13
]
QUESTIONS_THAT_MATTER_FOR_THETA_CALCULATION = [1, 2, 5, 6, 7, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35]

MAP_QUESTION_TO_INDEX_IN_MANUAL = {
    'El diseño de juego es atractivo': 'i1',
    'La fuente de texto y los colores están bien combinados y son consistentes': 'i2',
    'Tuve que aprender cosas antes de poder jugar': 'i3',
    'Aprender a jugar se me hizo fácil ': 'i4', # There is a space in the csv file for some reason
    'Creo que el juego es fácil de jugar.': 'i6',
    'Las reglas del juego son claras y fáciles de entender': 'i7',
    'Las fuentes (su tamaño y estilo) usadas son fáciles de leer': 'i8',
    'Los colores usados en el juego son significativos': 'i9',
    # i10 - i12 were not asked because they have multiplayer components
    'Cuando vi el juego por primera vez, tuve la sensación de que sería fácil para mí': 'i13',
    'La estructura me ayudó a tener confianza en que aprendería con este juego': 'i14',
    'Este juego es desafiante en la medida justa': 'i15',
    'El juego ofrece nuevos desafíos a un ritmo adecuado': 'i16',
    'El juego no se vuelve monótomo a medida que se avanza': 'i17',
    'Completar las tareas del juego me provocó satisfacción': 'i18',
    'Pude avanzar en el juego gracias a mi esfuerzo personal': 'i19',
    'Siento satisfacción con lo aprendido en este juego': 'i20',
    'Recomendaría este juego a mis colegas': 'i21',
    # 'I was able to interact with other players during the game': 'i22',
    # 'The game promotes cooperation and/or competition among the players': 'i23',
    # 'I felt good interacting with other players during the game': 'i24',
    'Me entretuve con el juego': 'i25',
    'Algún elemento del juego me hizo sonreír': 'i26',
    'Había algo interesante al inicio del juego que llamó mi atención': 'i27',
    'Estaba tan envuelt@ en la tarea propuesta por el juego que perdí la noción del tiempo': 'i28',
    'Me olvidé de mi entorno físico mientras jugaba': 'i29',
    'Los contenidos del juego son relevantes para mis intereses': 'i30',
    'Es claro ver que los contenidos del juego se relacionan a cierta materia de la carrera': 'i31',
    'Este juego es adecuado para enseñar el contenido': 'i32',
    'Prefiero aprender con este juego en vez de aprender con otros métodos de enseñanza': 'i33',
    'El juego contribuyó a mi aprendizaje': 'i34',
    'El juego me permitió aprender de forma eficiente en comparación con otras actividades': 'i35'
}



class UserRegister:
    """ User registers come from the .tsv files in the google forms in a rather hard to analyze way.
    i.e. {"Marca temporal" : 2023/04/12 12:35:35 a. m. GMT-3,
    "Por favor, contesta las siguientes preguntas [El diseño de juego es atractivo]": "Muy de acuerdo", 
    "Por favor, contesta las siguientes preguntas [La fuente de texto y los colores están bien combinados y son consistentes]": "De acuerdo",
    ...
    So, each key should consider only the part between the square brackets and have its key.
    This class will keep the UserRegister class simple
    """
    _QUESTION_REGEX_PATTERN = r'\[([^\]]+)\]'
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
            reader = csv.DictReader(file, delimiter="\t")
            for row in reader:
                # Assuming the Google Form headers are in the first row of the CSV file
                # You can access the columns by their header names, for example: row['Column_Name']
                ret.append(UserRegister(row))

    except FileNotFoundError:
        print("File not found. Please check the file path and try again.")
        raise

    except Exception as e:
        print(f"An error occurred: {e}")
        raise

    return ret


# First we save every register separated per question in this format
# Register1 = {Q1: value11, Q2: value21, Q3: value31}
# Register2 = {Q1: value12, Q2: value22, Q3: value32}

def main(input_path=ORIGINAL_FILE_NAME, output_path=MEEGA_PLUS_CSV_ANSWERS_NAME, middle_files_prefix=''):
    """
    Read the user registers and turn it into a CSV where the columns are the questions,
    and the answers are just coma-separated values from 1 to 5.
    """
    results_csv = read_csv(input_path)
    columns = results_csv[0].questions
    dict_df = {key : [] for key in columns}
    for row in results_csv:
        for question, answer in zip(columns, row.answers):
            dict_df[question].append(answer)
    """
    The df_questions_answers will contain the questions and answers in a friendly way. i.e:
    "El diseño de juego es atractivo": [5, 2, 4, 5, 3, 5, 5, 5...] and so on for each question
    and will be saved in the path: form_csv_path
    """
    df_questions_answers = pd.DataFrame(dict_df)
    form_csv_path = f"{middle_files_prefix}ProcessedAnswersFromGoogleForms.csv"
    df_questions_answers.to_csv(form_csv_path)
    

    # Create a new DataFrame with renamed columns, i1, i2, ... i35. df_meega has all questions and answers
    df_meega = df_questions_answers.rename(columns=MAP_QUESTION_TO_INDEX_IN_MANUAL)
    df_meega.to_csv(f"{middle_files_prefix}meega_answers_for_graph_and_table.csv")
    """
    But we also want to map this into the EXTRA.csv given by Petri et al
    # We want to create a dataframe like this:
    # Person index |  i1  |  i2  |  i3  | ...
    #      1       |  2   |  -1  |  0   | ...
    #      2       |  1   |  -1  |  2   | ...
    #      3       |  -2  |  -2  |  1   | ...
    .............

    So first, we need to remap the questions in Spanish to the question indices in the user manual of MEEGA+
    """ 
    # Erase the columns that are not important for the calculation of the theta value:
    df_for_theta = df_meega.drop(labels=QUESTIONS_THAT_ARE_NOT_FOR_THETA_CALCULATION, axis=1)
    # Add the first column, that is ID | 1 | 2 | 3 | ... | N
    values_of_first_column = range(1, len(df_for_theta) + 1)
    df_for_theta.insert(0, 'ID', values_of_first_column)
    # We are not including the i22, i23, i24
    df_for_theta.to_csv(f'MEEGAEvaluation/{output_path}', index=False, sep=';')
    print(f'Results have been saved as {output_path} successfully!')


if __name__ == "__main__":
    main()
