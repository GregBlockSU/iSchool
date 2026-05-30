'''
    This program processes a DB collection of tweets and returns the top frequency hashtags.
        The Mongod server must be running.
        The number parameter is the number of top frequency hashtags to print.
    Usage:  python twitter_hashtags.py <DBname> <DBcollection> <number>
    Example:  python twitter_hashtags.py mmquery mmv1  20
'''

import sys
from operator import itemgetter
import pandas as pd
import pymongo
import json
from bson.json_util import dumps

# this function contains a function to return lists of some twitter entities
# for each tweet, this function returns lists of the entities:  mentions, hashtags, URLs
# Parameter:  a tweet (as a Twitter json object)
# Result:  3 lists of the above entities
def get_entities(tweet):
    # make sure this is a tweet by checking that it has the 'entities' key
    if 'entities' in tweet.keys():
        # list of mentions comes from the 'screen_name' field of each user_mention
        mentions = [user_mention['screen_name'] for user_mention in tweet['entities']['user_mentions']]   
        # list of hashtags comes from the 'text' field of each hashtag
        hashtags = [hashtag['text'] for hashtag in tweet['entities']['hashtags']] 
        # list of urls can come either from the 'url' field  or 'expanded_url' field of each url
        urls = [urlitem['url'] for urlitem in tweet['entities']['urls']]    
        urls = urls + [urlitem['expanded_url'] for urlitem in tweet['entities']['urls']] 
        # we ignore the symbols and optional media entity fields
        return mentions, hashtags, urls
    else:
        # if no entities key, return empty lists
        return [], [], []
    
# This function gets data from an existing DB and collection
# Parameters:  
#   DBname and DBcollection- the name of the database and collection, either new or existing
# Result:
#   data - returns all the data in the collection as a list of JSON objects

def load_from_DB (DBname, DBcollection):
    # connect to database server and just let connection errors fail the program
    client = pymongo.MongoClient('localhost', 27017)
    # use the DBname and collection, which will create if not existing
    db = client[DBname]
    collection = db[DBcollection]           
    # get all the data from the collection as a cursor
    docs = collection.find()
    #  convert the cursor to a list
    docs_bson = list(docs)
    docs_json_str = [dumps(doc) for doc in docs_bson]
    docs_json = [json.loads(doc) for doc in docs_json_str]
    return docs_json

def print_tweet_data(tweets):
    for tweet in tweets:
        print('\n Date:', tweet['created_at'])
        print('From:', tweet['user'])
        print('Message', tweet['text'])

# load all the tweets
tweet_results = load_from_DB('bball', 'bbcoll')
tweet_df = pd.DataFrame(tweet_results)

print('tweets')
print(tweet_df.head())

# Create a frequency dictionary of the hashtags, 
#   a dictionary where the keys are hashtags and the values are the frequency (count)
hashtag_fd = {}
for tweet in tweet_results:
    # get the three entity lists from this tweet
    (mentions, hashtags, urls) = get_entities(tweet)
    # put the hashtags in the frequency dictionary
    for tag in hashtags:
    # if the tag is not yet in the dictionary, add it with the count of 1
        if not tag in hashtag_fd:
            hashtag_fd[tag] = 1
        else:
            # otherwise, add 1 to the count that is already there
            hashtag_fd[tag] += 1
# sort the dictionary by frequency values, returns a list of pairs of words and frequencies
#   in decreasing order   
hashtags_sorted = sorted(hashtag_fd.items(), key=itemgetter(1), reverse=True)
# print out the top number of words with frequencies
# go through the first 20 tweets and find the entities
print("Top", 20, "Frequency Hashtags")
#for (word, frequency) in hashtags_sorted[:20]:
 #   print (word, frequency)
    

# load the tweet id and language into dataframe columns
tweet_df['id'] = [tweet['id'] for tweet in tweet_results]
tweet_df['lang'] = [tweet['lang'] for tweet in tweet_results]
tweet_df['user'] = [tweet['user'] for tweet in tweet_results]
tweets_by_lang = tweet_df['lang'].value_counts()

user_df = pd.DataFrame()
user_df['user']= [tweet_df['user'] for tweet in tweet_results]
print(str(user_df))
# write a dateframe.
#print(tweets_by_lang)

# number of languages is first item in shape
numlang = tweets_by_lang.shape[0]


