import csv

source_file = 'donors_data.csv'

with open(dource_file, 'rU') as csv_file:
    csv.reader(csv_file, header=1)