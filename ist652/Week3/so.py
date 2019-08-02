###################code input#########################
####reading data 
NBAfile=open('NBA-Attendance-1989.txt','r')
lines =  NBAfile.readlines()

for line in lines:
    line.strip();
    items = line.split()
    print(items)
    
    if (items[1] == ""):
    # 
        targetString = "YYYThe attendance at" + str(items[0]) + "was " + str(items[2]) + " and the ticket price was $" + str(items[3])
    else:
        targetString =  "The attendance at" + str(items[0]) + "was " + str(items[1]) + " and the ticket price was $" + str(items[2])
    
    print (targetString)

