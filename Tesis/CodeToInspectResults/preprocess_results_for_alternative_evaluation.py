from preprocess_results import main as process_results

def main():
    INPUT_FILE_NAME = "EvaluacionIGACSEAlternativa.tsv"
    MEEGA_PLUS_CSV_ANSWERS_NAME = "EXTRAAlternative.csv"
    PREFIX_FOR_MIDDLE_FILES = "Alternative_"
    process_results(
        input_path=INPUT_FILE_NAME,
        output_path=MEEGA_PLUS_CSV_ANSWERS_NAME,
        middle_files_prefix=PREFIX_FOR_MIDDLE_FILES,
    )

if __name__ == "__main__":
    main()