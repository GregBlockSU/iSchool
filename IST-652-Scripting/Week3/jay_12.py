with open('state_satscores_2004.tsv') as StateScores:  #open the file for use
    StateScoreData = csv.reader(StateScores, delimiter='\t') 
print("States with a mean Math SAT score >500:")  #header to infrom user of what information follows
for StateData in StateScoreData:   #loop through the file and assign each line as a list
 #For the line evaluate if the the mean verbal score for that state is above the current highest value
    if int(StateData[1]) > MaxVerbalScore: 
#if the verbal score is above the current highest value change the Max Verbal Score Value 
# and store the name of the state
        MaxVerbalScore = int(StateData[1])
        MaxVerbalState = StateData[0]
#Evaluate if the mean Math score is greater than 500
    if int(StateData[2]) > 500:
#If the mean math Score is greater than 500, print the state name
        print(StateData[0])

#Print the state with the highest mean Verbal SAT Score
print("\nState with the highest mean Verbal SAT Score: ", MaxVerbalState)