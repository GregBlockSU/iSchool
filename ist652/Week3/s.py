statfile=open('state_satscores_2004.txt','r')       

filename = "state_satscores_2004.txt"


# we need state with highest mean Verbal Stat scors
# print state with mean Math score greater than 500
# ASSUMPTION Maths is third and verbal is second

state_scores = []
with open(filename, 'r') as file: #we open in read mode 
  for line in file:
      state_scores.append(line.strip().split("\t"))

# do you have any questions?

state_wt_highest = state_scores[0]
print("States with mean Math Sat score greater than 500: ") 
for state_score in state_scores:
    if int(state_score[1]) > int(state_wt_highest[1]):
        state_wt_highest = state_score
    if int(state_score[2]) > 500:
        print(state_score)

print("State with the the higest mean verbal score is: ", state_wt_highest[0])        