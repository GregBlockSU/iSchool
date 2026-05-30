'''
	This program file must be edited with a new temporary FaceBook access token every hour.
	The function is called to make the facebook connection.
'''

import facebook

# login to FaceBook to gain access to the graph API
def fb_login():
  # get an access token from the Graph Explorer web page
  #   https://developers.facebook.com/tools/explorer
  ACCESS_TOKEN = 'EAACEdEose0cBADr1Q2I1ZCEedJot6bRKD0ECHjlvZCzfhZCUUQKf4j3i1qduZAUDT80RKOZAq3Ijp17Hiy3i9dXRC6ZAHwnFXVYZB9MEhSWHDlva1USrigg1C8PhoSn1KdMFikTMNZADxmWCFG4ryjkh25BREhenZCHg3up70cKTZBEGC1QLfRCQarvzLaZA6IZAvt0ZD'
  
  # get the authorization from facebook and return
  fb  = facebook.GraphAPI(ACCESS_TOKEN)
  return fb