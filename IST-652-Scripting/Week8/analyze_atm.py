import csv
import pandas as pd
import matplotlib.pyplot as plt

FILE_NAME = 'atm_daily.txt'

def get_data():
    atm_data = pd.read_csv(FILE_NAME,sep='|')
    print(atm_data.head())
    return atm_data


atm_df = get_data()
one_atm_df = atm_df.query('atm_id==1')
plt.plot(one_atm_df['trans_date'], one_atm_df['bal'])
plt.show()
