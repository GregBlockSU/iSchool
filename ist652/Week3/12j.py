import csv

file = 'state_satscores_2004.tsv' #file location
state_list = [] #empty list to store dictonaries
#creates key-value pairs for each line in the tsv
with open(file, 'rU') as csvfile:
    state_reader = csv.reader(csvfile, dialect='excel', delimiter = '\t')
    for line in state_reader:
        state = {}
        state['name'] = line[0]
        state['verbal'] = int(line[1])
        state['math'] = int(line[2])
        state_list.append(state)
    csvfile.close()
Verbal = []

#for loop to extract scores
for state in state_list:
    Verbal.append(state['verbal'])

print(state_list)

print(int(state['verbal'] == max(Verbal)))

#finds line where the highest mean verbal SAT score is and prints value
#associated with that 'name' key
best_state = state_list[state['verbal'] == max(Verbal)]
print(best_state['name'])