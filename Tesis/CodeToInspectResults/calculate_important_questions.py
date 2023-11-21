"""
Script intended to create graph results analyzing the answers of the users.
Form URL: https://forms.gle/6JXo8FmPmmarP2AA6
"""

questions = [i for i in range(1, 36)]
# The script in R shows a vector -c(1,3,4,5,9,10,11,12,13,14) for exclusion, but the first column
# Is the ID of the question, so this is not considered
excluded_questions_from_script = [3, 4, 5, 9, 10, 11, 12, 13, 14] # script_tri_score.R excludes these questions

# TODO: Compute this. In order to get this, we need to get the questions from our formulare and see which are not in the 35 set

exclueded_questions_from_other_paper_formulare = [ ]



remaining_questions = [q_i for q_i in questions if q_i not in excluded_questions_from_script]
print(f'The remaining questions are {remaining_questions}')


# After looking at this, we have to take care that the param.csv file contains the parameters of the questions that are important to us