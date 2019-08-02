# Import the Pandas Program
import pandas as pd

# Import Donors file into data frame
df = pd.read_csv('donors_data.csv')

#create data frames for each of the regions by each of the genders
region1m = df[(df['zipconvert_2'] == 1) & (df['gender dummy'] == 0)]
region1f = df[(df['zipconvert_2'] == 1) & (df['gender dummy'] == 1)]
region2m = df[(df['zipconvert_3'] == 1) & (df['gender dummy'] == 0)]
region2f = df[(df['zipconvert_3'] == 1) & (df['gender dummy'] == 1)]
region3m = df[(df['zipconvert_4'] == 1) & (df['gender dummy'] == 0)]
region3f = df[(df['zipconvert_4'] == 1) & (df['gender dummy'] == 1)]
region4m = df[(df['zipconvert_5'] == 1) & (df['gender dummy'] == 0)]
region4f = df[(df['zipconvert_5'] == 1) & (df['gender dummy'] == 1)]

# find max donation by each gender for each region
print('The region 1 max donation for male is {:.2f}'.format(max(region1m['MAXRAMNT'])))
print('The region 1 max donation for female is {:.2f}'.format(max(region1f['MAXRAMNT'])))
print('The region 2 max donation for male is {:.2f}'.format(max(region2m['MAXRAMNT'])))
print('The region 2 max donation for female is {:.2f}'.format(max(region2f['MAXRAMNT'])))
print('The region 3 max donation for male is {:.2f}'.format(max(region3m['MAXRAMNT'])))
print('The region 3 max donation for female is {:.2f}'.format(max(region3f['MAXRAMNT'])))
print('The region 4 max donation for male is {:.2f}'.format(max(region4m['MAXRAMNT'])))
print('The region 4 max donation for female is {:.2f}'.format(max(region4f['MAXRAMNT'])))

# Compare donors by the number of promotions with the total amount of donations and the frequency of donations

# figure out the range of promotions to create 3 equal groups
promotions = df['NUMPROM']
mxp=(max(promotions))
mip=(min(promotions))
threegp = (mxp-mip)/3
print(mxp)
print(mip)
print(round(threegp,0))

# create the three groups
lowpromo = df[(df['NUMPROM'] <= 60)]
highpromo = df[(df['NUMPROM'] >= 106)]
midpromo = df[(df['NUMPROM'] >= 61) & (df['NUMPROM'] <= 105)]

#compare total donations and frequency of donations by each group
print('The low promo group on average gives {:.2f}'.format(sum(lowpromo['RAMNTALL'])/len(lowpromo['RAMNTALL'])),
      'total donations and on average contributes every {:.2f}'.format(sum(lowpromo['totalmonths'])/len(lowpromo['totalmonths'])),'months')
print('The mid promo group on average gives {:.2f}'.format(sum(midpromo['RAMNTALL'])/len(midpromo['RAMNTALL'])),
      'total donations and on average contributes every {:.2f}'.format(sum(midpromo['totalmonths'])/len(midpromo['totalmonths'])),'months')
print('The high promo group on average gives {:.2f}'.format(sum(highpromo['RAMNTALL'])/len(highpromo['RAMNTALL'])),
      'total donations and on average contributes every {:.2f}'.format(sum(highpromo['totalmonths'])/len(highpromo['totalmonths'])),'months')