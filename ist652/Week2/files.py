import sys

def get_text(path):
    with open(path, encoding="utf-8") as f:
        lines = [x.rstrip() for x in f]
        return lines

if len(sys.argv) == 0:
    print("Usage: python files.py file_name")
else:
    path = sys.argv[1]
    print(f"Opening file {path}")
    try:
        lines = get_text(path)
        for line in lines:
            print(line)
    except Exception as e: 
        print(e)