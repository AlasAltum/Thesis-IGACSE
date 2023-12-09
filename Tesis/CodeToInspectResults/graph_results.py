"""
Script intended to create graph results analyzing the answers of the users.
Form URL: https://forms.gle/6JXo8FmPmmarP2AA6
"""

import os

import matplotlib.pyplot as plt
import pandas as pd
import numpy as np


INPUT_CSV_FILE = "SumOfResultsIGACSE.csv"
OUTPUT_GRAPH_NAME = "answers.png"


current_directory = os.path.dirname(os.path.abspath(__file__))
csv_full_file_path = os.path.join(current_directory, INPUT_CSV_FILE)
"""
Read the data and transform it into a dataframe. We use the following format:

Questions: Q1; Q2; Q3, .... Q31
Strongly disagree: 0, 2, 5, ...
Disagree: 2, 1, 3, ...
Not disagree nor agree: 5, 1, 2, ...
Agree: 3, 2, 0, ...
Strongly agree: 5, 2, 4, ...
"""

df = pd.read_csv(csv_full_file_path, delimiter=';')

# We want to plot: for each question, the number of times each category was marked.
categories = [
    'Muy en desacuerdo',
    'En desacuerdo',
    'Ni en desacuerdo ni de acuerdo',
    'De acuerdo',
    'Muy de acuerdo',
]
# question_indexes = [1, 9] U [13, 21] U [25, 35]
questions_indexes = [f'Q{i}' for i in range(1, 10)]
questions_indexes.extend([f'Q{i}' for i in range(13, 22)])
questions_indexes.extend([f'Q{i}' for i in range(25, 36)])
values = df.loc[:, 'Q1':'Q35'].values  # Numpy array that can be plotted with bars, it has all the values

plt.figure(figsize=(15, 6))
bar_width = 0.15
q_indexes = np.arange(len(questions_indexes))

# Show the 31 bars for each category
for i, category in enumerate(categories):
    bars = plt.bar(
        x=q_indexes + i * bar_width,
        height=values[i, :],
        width=bar_width,
        label=category
    )


# Customize the plot
plt.xlabel('Pregunta y Categoría')
plt.ylabel('Número de respuestas')
plt.title('Número de respuestas por categoría para cada pregunta')
plt.xticks(q_indexes + bar_width * 2, questions_indexes)  # Items: Show Q1, Q2, Q3... Q31
plt.legend(title='Categorías')

# Show the plot
plt.tight_layout()
plt.show()

plt.savefig(OUTPUT_GRAPH_NAME, bbox_inches='tight')

# Print the path where the plot is saved
print(f'Plot saved as: {OUTPUT_GRAPH_NAME}')
