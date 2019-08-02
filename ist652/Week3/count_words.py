import sys

# get_file will chck the command line to see if a file name was provided; if not,
# prompts for a file name. If the file can be opened, its handle is returned; 
# otherwise, the program exits
def get_file():
    file_name = ""
    if len(sys.argv) == 1:
        file_name = input('Enter the name of a text file: ')
    else: 
        file_name = sys.argv[1]
    try:
        text_file = open(file_name)
        return file_name, text_file
    except:
        print(f'File {file_name} cannot be opened:')
        exit()

# count_words methods extracts all the lines and words from text_file
# and stores the words in a dictionary; the value assigned to each
# word in the dictionary is the frequency of occurrence
def count_words(text_file):
    word_counts = dict()
    for line in text_file:
        words = line.strip().split()
        for word in words:
            lword = word.lower()
            if lword in word_counts:
                word_counts[lword] = word_counts[lword] + 1
            else:    
                word_counts[lword] = 1
    return word_counts

# print_words_by_count expects a dictionary of words and their frequencies;
# filters the dictionary by value to remove any items with a frequency less 
# than filter; then sorts the dictionary by value to print each item
def print_words_by_count(word_counts, filter):
    filtered_counts = {k : v for k, v in word_counts.items() if v > filter}
    for word in sorted(filtered_counts, key = filtered_counts.get, reverse=True):
        print(f"Word '{word}' has a frequency of {filtered_counts[word]}")

# the main logical flow opens a file, extracts the word count,
# closes the file and prints the results
file_name, text_file = get_file()
print(f'Opening file {file_name}')
word_counts = count_words(text_file)
text_file.close()
print_words_by_count(word_counts, 3)
