'''
    This main function retrieves documents from a file and writes them to a Mongo database collection,
        where each line of the file is a document represented as a json item
    It assumes that the Mongo DB server is running.
    Command line usage:
        python DB_from_file.py <DB name> <collection name> <filepath>
    Example:      python DB_from_file.py fbusers cdelta out/fb-delta-feed.txt 
        (where quotes may not be necessary)
'''

import json
import sys
from DB_fn import save_to_DB

# use a main so can get command line arguments
if __name__ == '__main__':
    # Make a list of command line arguments, omitting the [0] element
    # which is the script itself.
    args = sys.argv[1:]
    if not args or len(args) < 3:
        print('usage: python DB_from_file.py <DB name> <collection name> <filepath>')
        sys.exit(1)
    DBname = args[0]
    DBcollection = args[1]
    filename = args[2]  
    
    # get the data from the file
    fload = open(filename, encoding='utf-8')
    resultString = fload.read()
    # loads converts from a string back to a json structure
    doclist = json.loads(resultString)  
    print ("Read", len(doclist), "from file:", filename)

    # in case this was saved from a database, we delete the database id key _id, so that DB will assign unique key
    for doc in doclist:
        if '_id' in doc.keys():
            del doc['_id']
    
    # use the save and load functions in this program
    save_to_DB(DBname, DBcollection, doclist)

