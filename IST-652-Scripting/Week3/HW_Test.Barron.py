#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Oct 30 14:45:29 2018

@author: emeliabarron
"""

"""
Created on Sat Oct 27 07:32:57 2018

@author: emeliabarron
"""

## LOAD PACKAGES

import pandas as pd 
import numpy as np
import matplotlib.pyplot as plt

data = pd.read_csv("donors_data.csv", encoding='utf-8') 
print(type(data))
data

## DATA CLEANING AND PREPROCESSING
#%%
print(data.shape)
print(data.columns)
#%%
print(data.dtypes) #all datatypes are int64 or float64
print(data.describe())

#%%
# missing values?
print("missing values? {}".format(data.isnull().any().any()))
#missing value control in features
print(data.isnull().sum())
# yay! there are no missing values
#%%

## ANALYSIS

# WHAT IS THE DISTRIBUTION OF DONATION AMOUNTS?
plt.hist(data.TARGET_D)
plt.title('Distribution of Donor Donation Values Histogram')
plt.xlabel('Donation Values ($)')
plt.ylabel('Count of Donations')
plt.show()
#most donations are less that $25
data.TARGET_D.describe()


#%%
# WHAT ARE THE TOP DONATIONS?
#TopDonors = data[data.TARGET_D>50]
#plt.hist(TopDonors.TARGET_D)
#plt.show()

#%%
# WHAT ARE THE AVERAGE DONATION AMOUNTS BASED ON GENDER OF DONOR AND THE NUMBER OF CHILDREN? 
DF1 = data.groupby(["gender dummy", "NUMCHLD"])["TARGET_D"].mean()
print('data.groupby(["gender dummy", "NUMCHLD"])["TARGET_D"].mean()')
print(DF1)
# 0 = Male, 1 = Female
# males who have 2 children donate a mean of $7.2 ....

#save as csv
DF1.to_csv('AvgDonationVS.GenderVs.NumChld.csv', encoding ='utf-8', index=True, header=True)

#%%
# WHAT IS THE AVERAGE DONATION AMOUNT BASED ON NUMBER OF CHILDREN? 
#DF2 = data.groupby(["NUMCHLD"])["TARGET_D"].mean()
#print(DF2)
# grouped by number of children an summarizd by the mean donation amount
# example: a person with 1 child donates about $6.56 and a person with 5 children does not donate at all

#save as csv
#DF2.to_csv('AvgDonationVS.NumChld.csv', encoding ='utf-8', index=False)