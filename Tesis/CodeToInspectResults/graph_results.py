"""
Script intended to create graph results analyzing the answers of the users.
Form URL: https://forms.gle/6JXo8FmPmmarP2AA6
"""


try:
    import pandas as pd
    OUTPUT_FILENAME = "ProcesamientoArchivos.csv"
    output_df = pd.read_csv(OUTPUT_FILENAME)
except: 
    from preprocess_results import output_df

# output_df has everything we need to graph
import matplotlib.pyplot as plt

 
