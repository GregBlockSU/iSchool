from pymongo import MongoClient

client = MongoClient('localhost', 27017)

# show existing databases
print(client.list_database_names())