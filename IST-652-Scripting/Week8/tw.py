import pymongo
client = pymongo.MongoClient('localhost',27017)

#list the databases defined
client.database_names()
db = client.bball
db.collection_names()
coll=db.bbcoll
docs = coll.find()

#convert the document cursor to a list of documents
doclist = [tweet for tweet in docs]
len(doclist)

# show difference from print
print(doclist[:1])

# Look through this to point out field names
# Here is a little print function that will help.
def print_tweet_data(tweets):
    for tweet in tweets:
        print('\nDate:', tweet['created_at'])
        print('From:', tweet['user']['name'])
        print('Message', tweet['text'])

print_tweet_data(doclist[:5])
