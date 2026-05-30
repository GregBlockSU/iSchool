from pymongo import MongoClient
import pprint
import bson

client = MongoClient('localhost', 27017)

# show existing databases
print(client.list_database_names())

# get the bbcoll collection
bball = client.bball
bbcoll = bball.bbcoll

print('find_one example')
print('------------------------------------------')
one_tweet = bbcoll.find_one({"id_str": "846463866863276032"}, {'text': 1, 'country_code'})
print(one_tweet)

print('find iPhones example')
print('------------------------------------------')
regx = bson.regex.Regex('iPhone</a>$')
iphone_tweets = bbcoll.find({'source': regx }, {'text': 1, 'country_code'})
for tweet in iphone_tweets.sort("country_code").limit(5):
    print(tweet)