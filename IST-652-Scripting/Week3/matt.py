# Lab 1 solution
# import pandas as pd
nbafile = open("NBA-Attendance-1989.txt","r")
nbalist=[]
for line in nbafile:
    textline = line.strip() #remove whitespace
    items = textline.split() #split entries onto separate lines
    nbalist.append(items)

for game, attendance, price in nbalist:
    print(f"The attendance at {game} was {attendance} and the ticket price was ${price}.")


# Bonus: User input prompt.
while True:
    question = input("What is the NBA team about which you are inquiring? ")
    try:
        for game, attendance, price in nbalist:
            if question == game:
                print(f"The attendance at {game} was {attendance} and the ticket price was ${price}.")
                break
        else:
            print("Bad input")
            break
    except ValueError:
        print("Bad input")
        break