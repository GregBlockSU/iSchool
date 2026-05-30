'''
	This program processes a facebook DB collection of posts and counts likes, comments and comment likes.
		Note that if the number of likes is over 25, these were not collected.
		This program does not get the number of shares.
		The Mongo server must be running.
	Usage:  python facebook_counts.py <DBname> <DBcollection>
	Example:  python facebook_counts.py fbusers delta
'''

import sys
from DB_fn import load_from_DB
#from File_fn import load_from_file

# use a main so can get command line arguments
if __name__ == '__main__':
	# Make a list of command line arguments, omitting the [0] element
	# which is the script itself.
	args = sys.argv[1:]
	if not args or len(args) < 2:
		print('usage: python facebook_counts.py <DBname> <DBcollection>')
		sys.exit(1)
	DBname = args[0]
	DBcollection = args[1]

	# load all the facebook posts
	posts = load_from_DB(DBname, DBcollection)
    # use the dbname for the filename and ignore the collection name
	#posts = load_from_file(DBname)

	# number of likes of posts
	numlikes = 0
	# number of comments on posts
	numcomments = 0
	# number of likes on comments
	numcommentlikes = 0

	#  process all the posts
	for post in posts:
    	# count the number of likes
		if ("likes" in post.keys()):
			# the length of the likes data list is the number of likes of this past, capped at 25
			likelist = post["likes"]["data"]
			numlikes += len(likelist)
		# count the number of comments
		if ("comments" in post.keys()):
			# the length of the comments data list is the number of comments of this post, capped at 25
			commentlist = post["comments"]["data"]
			numcomments += len(commentlist)
			# each comment has a likes count
			for comment in commentlist:
				numcommentlikes += comment["like_count"]

	# print out the results
	print("Counts for", len(posts), "facebook posts, showing user activity")
	print("Number of post likes:", numlikes)
	print("Number of comments on posts:", numcomments)
	print("number of likes on comments:", numcommentlikes)

