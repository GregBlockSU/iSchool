from decimal import *
import csv

# region NBA-Attendance-1989
from typing import List, Any

nba_list = []

# open the file and copy each line to an array
with open('NBA-Attendance-1989.txt') as nba_file:
    for each_line in nba_file:
        team, attendance, ticket = each_line.strip().split()
        nba_list.append([team, int(attendance), Decimal(ticket)])

# close the file as soon as possible

# print team information
print("-------- NBA Attendance 1989 ---------")
for team, attendance, ticket in nba_list:
    print('Team {0} had attendance {1} with ticket price {2:5.2f}'.format(team, attendance, ticket))

# calculate team metrics
total_attendance = sum(attendance for team, attendance, ticket in nba_list)
max_attendance: int = max(attendance for team, attendance, ticket in nba_list)
max_ticket_price: Decimal = max(ticket for team, attendance, ticket in nba_list)

# note the use of or [None])[0] -- this pulls the first item out of the list
team_with_max_attendance = ([team for team, attendance, ticket in nba_list if attendance == max_attendance] or [None])[0]
team_with_max_ticket_price = ([team for team, attendance, ticket in nba_list if ticket == max_ticket_price] or [None])[0]

# print team metrics
print('Number of teams: {0}'.format(len(nba_list)))
print(f"Total attendance is {total_attendance} ")
print(f"Team {team_with_max_attendance} has maximum attendance of {max_attendance}")
print(f"Team {team_with_max_ticket_price} has maximum ticket price of {max_ticket_price}")
# endregion

# region Using dictionaries

# create the dictionary
phone_dict = {'eric': '454-5555', 'john': '454-5195', 'michael': '454-9999', 'helen': '456-1234', 'don': '455-9988'}

# sort by contact
print("-------- sorting contacts by name ---------")
for contact, phone_number in sorted(phone_dict.items()):
    print(f"Contact {contact} uses phone number {phone_number}")

# sort by phone number
print("-------- sorting contacts by number ---------")
for contact, phone_number in sorted(phone_dict.items(), key=lambda kv: (kv[1], kv[0])):
    print(f"Contact {contact} uses phone number {phone_number}")

# sorting tuples
sort_tuples = [(1,7),(1,3),(3,4),(2,2)]
print("-------- sorting tuples by second value---------")
for lhs, rhs in sorted(sort_tuples, key=lambda each_tuple: (each_tuple[1])):
    print(f"Tuple {lhs} has value {rhs}")

print("-------- sorting tuples by number ---------")
for lhs, rhs in sorted(sort_tuples, reverse=True, key=lambda each_tuple: (each_tuple[1])):
    print(f"Tuple {lhs} has value {rhs}")

# endregion

# region CSV files
source_file = 'states_data.tsv'
state_list = []

with open(source_file, 'rU') as csv_file:
    state_reader = csv.reader(csv_file, dialect='excel', delimiter='\t')

    lines = [line for line in state_reader if line[0] != '' and not line[0].startswith('Data') and not line[0].startswith('*')]
    for each_line in lines:
        state_name = each_line[0]
        state_abbrev = each_line[1]
        state_code = each_line[2]
        state_area = each_line[3].replace(',', '')
        state_pop = each_line[4].replace(',', '')
        state_list.append([state_name, state_abbrev, state_code, state_area, state_pop])

# close the file here

# print a few fields from all of the states read from the file
print("-------- state information ---------")
for state_name, state_abbrev, state_code, state_area, state_pop in state_list:
    print(f"State: '{state_name}'', abbreviation '{state_abbrev}'', code '{state_code}'', area '{state_area}'', population '{state_pop}'")
# endregion
