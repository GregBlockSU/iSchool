
'''
    The primary goal of this program is to provide a function that will make a Facebook request
        for a connection field of a particular node (person/company). 
    It takes the Facebook connection, the name or id of the node, the field to retrieve, and the max number.
        The field can be 'feed' to get all the posts on the node's page.

    The secondary goal is to provide a main for a test function that retrieves and prints one or more results.
    Command line usage:
        python facebook_request_fn.py <query> <field> <num> 
    Example:      python facebook_request_fn.py DinosaurBarBQue feed 200 
'''

import sys
import json
import facebook
import requests
from facebook_login_fn import fb_login

# Parameters: 
#    the Facebook api connection
#    the Facebook id or name of the Facebook node (page)
#    the connection field to get (e.g., 'friends', 'feed', 'posts', 'statuses')
#    additional keyword arguments to pass to the Facebook api function
def facebook_connection_request(fb, arg_id, arg_field, max_results, **kw):
    
    # start a list to keep the data results
    resultList = []
    # make the first request using the Facebook sdk package with separate python arguments
    #   for convenience in making the first request
    nextResult = fb.get_connections(arg_id, arg_field, **kw)
    # add the data to the list of results
    resultList.extend(nextResult['data'])
    print ("Current number of results: ", len(resultList))
    
    # as long as a next page is available, keep making requests for chunks the size of limit
    while('paging' in nextResult) and ('next' in nextResult['paging']) and (len(resultList)< max_results):
        # get the URL for the next page of results using the paging key
        nextPage = nextResult['paging']['next']
        # use the requests package for the URL argument and use json to convert to python structure
        nextResult = requests.get(nextPage).json()
        # add the data to the list of results
        resultList.extend(nextResult['data']) 
        print ("Current number of results: ", len(resultList))
    
    # return the list of all the data found
    return resultList    

# simple utility function, pretty print, to nicely print dictionary of json objects
def pp(o):
    print (json.dumps(o, indent=2))

# test program for Facebook connection function 
# gets a number of requests and just prints first 20
if __name__ == '__main__':
    # Make a list of command line arguments, omitting the [0] element
    # which is the script itself.
    args = sys.argv[1:]
    if not args or len(args) < 3:
        print('usage: python facebook_request_fn.py <query> <field> <num> ')
        sys.exit(1)
    query = args[0]
    field = args[1]
    num = int(args[2])


    # make sure that this has a current access token
    fb  = fb_login()
    
    # set the limit to the number of items to get per request

    kw = { }
    kw['limit'] = 100
    
    # call the function with the fb id and the connection field that you want
    results = facebook_connection_request(fb, query, field, num, **kw)
    print ("Number of results found:", len(results))

    # in the case of results from the request for 'feed', results have "from"->"name" and "updated_time" fields
    print('First 20 posts:')
    for post in results[:20]:
        # optional message field
        if 'message' in post.keys():
            pnum = min([len(post["message"]), 100])
            print ("Post from:", post['from']['name'], " Date: ", post["updated_time"], " Message begin: ", post["message"][:pnum])
        else:
            print ("Post from:", post['from']['name'], " Date: ", post["updated_time"])

    # and print one complete results to see the fields
    print('One complete result')
    pp(results[0])
    
   