'''
    This program processes a DB collection of tweets and returns the top frequency hashtags.
        The Mongod server must be running.
        The number parameter is the number of top frequency hashtags to print.
    Usage:  python twitter_hashtags.py <DBname> <DBcollection> <number>
    Example:  python twitter_hashtags.py mmquery mmv1  20
'''

import sys
from operator import itemgetter
from DB_fn import load_from_DB

# this program contains a function to return lists of some twitter entities

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

# use a main so can get command line arguments
if __name__ == '__main__':
    # Make a list of command line arguments, omitting the [0] element
    # which is the script itself.
    args = sys.argv[1:]
    if not args or len(args) < 3:
        print('usage: python twitter_hashtags.py <DBname> <DBcollection> <number>')
        sys.exit(1)
    DBname = args[0]
    DBcollection = args[1]
    limit = int(args[2])

    # load all the tweets
    tweet_results = load_from_DB(DBname, DBcollection)

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
    print("Top", limit, "Frequency Hashtags")
    for (word, frequency) in hashtags_sorted[:limit]:
        print (word, frequency)

