# create an empty array to hold the scores
scores = []

# open the text file using the with clause so it is closed automatically
with open('state_satscores_2004.txt') as text_file:

    # for each line in the file, split the line into an array, and append the array
    # to the scores array
    for line in text_file:
        score = line.strip().split()
        scores.append(score)

# the with clause automatically closes the file

# find the element in the scores array with the highest secondary value
# and print it
highest_mean_verbal = max(scores, key = lambda x: int(x[1]))
print(f'\nThe state with the highest mean verbal score is {highest_mean_verbal[0]}')

# print all the states whose mean math scores exceed 500
print('\nListing all states with a mean math score exceeding 500')
for state, mean_verbal, mean_math in filter(lambda x: int(x[2]) > 500, scores):
    print(f'State {state} has a mean math score of {mean_math}')
