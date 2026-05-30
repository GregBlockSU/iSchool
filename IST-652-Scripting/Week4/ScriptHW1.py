# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

# Homework 1
import pandas as pd
# import dataset into pandas df
data = pd.read_csv("donors_data.csv")

# Corrected for wealth group:
# Does owning a home, having children, or gender
# have an effect on how much is given?


# number of donations by wealth group
# grouped_data tells how we should slice the dataset
grouped_data = data.groupby(['WEALTH'])
# using the slices created apply the mean function
avg_donations_wealth = pd.DataFrame({'Promotions': grouped_data['NUMPROM'].mean(), 
                                     'Avg Gift:': grouped_data['AVGGIFT'].mean()})
# count of the groups
count_wealth = pd.DataFrame({'Count': grouped_data['WEALTH'].count()}) 
# print(avg_donations_wealth)
# create plot for the data and a plot for the count
# if they are ploted together the count washes out the interesting stuff
avg_donations_wealth.plot(kind='bar')
count_wealth.plot(kind='bar').show()


# number of donations by wealth and if they own a home
grouped_data = data.groupby(['WEALTH', 'homeowner dummy'])
avg_donations_home = pd.DataFrame({'Promotions': grouped_data['NUMPROM'].mean(), 
                                     'Avg Gift:': grouped_data['AVGGIFT'].mean()}) 
count_home = pd.DataFrame({'Count': grouped_data['WEALTH'].count()})
# print(avg_donations_home)
avg_donations_home.plot(kind='bar')
count_home.plot(kind='bar').show()


# number of donations by wealth and number of children
grouped_data = data.groupby(['WEALTH', 'NUMCHLD'])
avg_donations_child = pd.DataFrame({'Promotions': grouped_data['NUMPROM'].mean(), 
                                     'Avg Gift:': grouped_data['AVGGIFT'].mean()}) 
count_child = pd.DataFrame({'Count': grouped_data['WEALTH'].count()})
# print(avg_donations_child)
avg_donations_child.plot(kind='bar').show()
count_child.plot(kind='bar').show()


# number of donations by wealth and gender. 
grouped_data = data.groupby(['WEALTH', 'gender dummy'])
avg_donations_gender = pd.DataFrame({'Promotions': grouped_data['NUMPROM'].mean(), 
                                     'Avg Gift:': grouped_data['AVGGIFT'].mean()}) 
count_gender = pd.DataFrame({'Count': grouped_data['WEALTH'].count()})
# print(avg_donations_gender)
avg_donations_gender.plot(kind='bar').show()
count_gender.plot(kind='bar').show()