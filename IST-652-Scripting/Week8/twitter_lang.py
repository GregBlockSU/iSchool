'''
    This program processes a DB collection of tweets and returns the languages used.
        The Mongod server must be running.
        The results are written to a csv file.
        The program uses pandas dataframes to represent the language for each tweet.
    Usage:  python twitter_lang.py <DBname> <DBcollection> <filename>
    Example:  python twitter_lang.py bball mm1 results.csv 
'''

import sys
from DB_fn import load_from_DB
import pandas as pd


# use a main so can get command line arguments
if __name__ == '__main__':
    # Make a list of command line arguments, omitting the [0] element
    # which is the script itself.
    args = sys.argv[1:]
    if not args or len(args) < 3:
        print('usage: python twitter_hashtags.py <DBname> <DBcollection> <filepath>')
        sys.exit(1)
    DBname = args[0]
    DBcollection = args[1]
    outfile = args[2]

    # load all the tweets
    tweet_results = load_from_DB(DBname, DBcollection)

    # create a dataframe
    tweet_df = pd.DataFrame()

    # load the tweet id and language into dataframe columns
    tweet_df['id'] = [tweet['id'] for tweet in tweet_results]
    tweet_df['lang'] = [tweet['lang'] for tweet in tweet_results]

    # create a new dataframe with the counts of languages used in the tweets
    tweets_by_lang = tweet_df['lang'].value_counts()

    # write a dateframe to a csv file.  the default separator is comma, sep=','
    tweets_by_lang.to_csv(outfile)

    # number of languages is first item in shape
    numlang = tweets_by_lang.shape[0]
    print('Wrote', numlang, 'to file')


