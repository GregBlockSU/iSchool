'''
  This program reads the data from the price of gasoline csv file 
    and uses only the numeric data
  Each line of the file has the year, followed by 12 months of gasoline prices
  We put the numeric fields in a numpy array and use the data for numeric operations.

  The outputs of the program are the averages of each month across the years
    and the averages for each year.
'''

import csv
import numpy as np

infile = 'Price_of_Gasoline.XL.csv'

# create new empty lists:  years and prices come from data
yearsList = []
pricesList = []
# names of months for labeling results
monthList = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']

# read the data
with open(infile, 'rU') as csvfile:
    # the csv file reader returns a list of the csv items on each line - note delimiter is comma
    priceReader = csv.reader(csvfile,  dialect='excel', delimiter=',')

    # from each line, a list of row items, make separate lists for years and for the prices
    for line in priceReader:
      # skip lines without data
      if line[0] == '' or line[0].startswith('Price') or line[0].startswith('Year'):
          continue
      else:
          try:
            # add the year to list
            yearsList.append(line[0])
            # append the prices (as strings) to the list
            pricesList.append(line[1:])
          except IndexError:
            print ('Error: ', line)
csvfile.close()

print ("Read", len(yearsList), "years of prices")

# make a numpy array for the strings
data = np.array(pricesList)
print('Shape of Prices data', data.shape)

# convert the empty strings to strings of zeros, using a Boolean mask to find empty strings
data[data == ''] = '0'

# now we can convert the whole thing to float without getting conversion errors for the empty strings
prices = data.astype(np.float)

#print(prices)

# compute the average price for each month (or use mean)
# sum along the columns
monthTotalPrices = np.sum(prices, axis = 0)
# divide by number of years to get average
monthAveragePrices = monthTotalPrices / len(yearsList)

#print(monthAveragePrices)
print ("\nAverage gas price for each month\n")

# print the average price for each month
for i, mon in enumerate(monthList):
	print (mon, ':', monthAveragePrices[i])

# compute the average price for each year up to the last one with missing data
# sum along the rows
yearTotalPrices = np.sum(prices, axis = 1)
# divide by number of months to get average
yearAveragePrices = yearTotalPrices / 12

#print(monthAveragePrices)
print ("\nAverage gas price for each year\n")

# print the 
for i, year in enumerate(yearsList[ :-1]):
  print (year ,':', yearAveragePrices[i])

# or display the monthly averages as a simple plot

import matplotlib.pyplot as pp

x = np.arange(12)
pp.xticks(x,monthList)
pp.plot(x, monthAveragePrices)
pp.show()


# or we can also display the years with a simple plot
x = np.arange(len(yearsList)-1)
pp.xticks(x,yearsList)
pp.plot(x, yearAveragePrices[:-1])
pp.show()

# Done!

