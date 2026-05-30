nbafile = open('nba-attendance-1989.txt')

nbalist=[]
for line in nbafile:
     nbalist.append(line.strip().split())

nbafile.close()

print(f'There are {len(nbalist):d} team(s) in the list')

for 'team', att, price in nbalist:
    print(f"The attendance at {team} was {int(att):d}, the ticket price was ${price}")

