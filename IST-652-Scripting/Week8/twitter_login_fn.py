''' Provides function that connects to Twitter
    Usage is shown in main test program
'''

import tweepy

# put the authorization codes here from your Twitter developer application
CONSUMER_KEY = 'Bh3oMqFDeFyfm4pot5frQAdKG'
CONSUMER_SECRET = 'ytikIPuy867T2fcGlVFFhlwSJd8aSR2CK0k1Yv4jk37MZf3noH'
OAUTH_TOKEN = '983117165716033537-OSY0vH40bmrSsian7n2wWXJ4TSeyWwH'
OAUTH_SECRET = '8w17C7Dj2oqyKzYw0Uibhff8V3ufPOjOD9f9nPaFLpeTT'

# login to Twitter with ordinary rate limiting
def oauth_login():
  # get the authorization from Twitter and save in the Tweepy package
  auth = tweepy.OAuthHandler(CONSUMER_KEY,CONSUMER_SECRET)
  auth.set_access_token(OAUTH_TOKEN,OAUTH_SECRET)
  tweepy_api = tweepy.API(auth)

  # if a null api is returned, give error message
  if (not tweepy_api):
      print ("Problem Connecting to API with OAuth")

  # return the Twitter api object that allows access for the Tweepy api functions
  return tweepy_api

# login to Twitter with extended rate limiting
#  must be used with the Tweepy Cursor to wrap the search and enact the waits
def appauth_login():
  # get the authorization from Twitter and save in the Tweepy package
  auth = tweepy.AppAuthHandler(CONSUMER_KEY,CONSUMER_SECRET)
  # apparently no need to set the other access tokens
  tweepy_api = tweepy.API(auth, wait_on_rate_limit=True, wait_on_rate_limit_notify=True)

  # if a null api is returned, give error message
  if (not tweepy_api):
      print ("Problem Connecting to API with AppAuth")

  # return the Twitter api object that allows access for the Tweepy api functions
  return tweepy_api
    
# Test program to show how to connect
if __name__ == '__main__':
  tweepy_api = oauth_login()
  print ("Twitter OAuthorization: ", tweepy_api)
  tweepy_api = appauth_login()
  print ("Twitter AppAuthorization: ", tweepy_api)