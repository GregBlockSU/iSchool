''' 
This main topic search function for Twitter using the python tweepy package
      Tries to get up to 1000 results from the Twitter REST/Search API search function
        using the tweepy Cursor to repeat the twitter search api requests
      The query string may be a keyword or hashtag, or a set of them connected by or
        example:  query = "#CuseLAX OR CNYlacrosse"
        some queries require quotes on the command line
    Returns a list of json formatted tweets
'''

import tweepy
import json
import sys
from twitter_login_fn import oauth_login
from twitter_login_fn import appauth_login
from DB_fn import save_to_DB


'''
  Uses the tweepy Cursor to wrap a twitter api search for the query string
    Returns json formatted results
'''

def simple_search(api, query, max_results=20):
  # the first search initializes a cursor, stored in the metadata results,
  #   that allows next searches to return additional tweets
  search_results = [status for status in tweepy.Cursor(api.search, q=query).items(max_results)]
  
  # for each tweet, get the json representation
  tweets = [tweet._json for tweet in search_results]
  
  return tweets

# use a main so can get command line arguments
if __name__ == '__main__':
    # Make a list of command line arguments, omitting the [0] element
    # which is the script itself.
    args = sys.argv[1:]
    if not args or len(args) < 4:
        print('usage: python twitter_simple_search.py <query> <num tweets> <DB name> <collection name>')
        sys.exit(1)
    query = args[0]
    num_tweets = int(args[1])
    DBname = args[2]
    DBcollection = args[3]

    # api = oauth_login()
    ''' if needed switch to using the appauth login to avoid rate limiting '''
    api = appauth_login()
    print ("Twitter Authorization: ", api)
    
    # access Twitter search
    result_tweets = simple_search(api, query, max_results=num_tweets)
    print ('Number of result tweets: ', len(result_tweets))

    # save the results in a database collection
    #   change names to lowercase because they are not case sensitive
    #   and remove special characters like hashtags and spaces (other special characters may also be forbidden)
    DBname = DBname.lower()
    DBname = DBname.replace('#', '')
    DBname = DBname.replace(' ', '')
    DBcollection = DBcollection.lower()
    DBcollection = DBcollection.replace('#', '')
    DBcollection = DBcollection.replace(' ', '')
    
    # use the save and load functions in this program
    save_to_DB(DBname, DBcollection, result_tweets)

    # Done!
  