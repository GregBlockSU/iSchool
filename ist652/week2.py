import os
import pandas

# region print the contents of every CSV file as a data frame
path = os.getcwd()
print('The current path is', path)
data_frames = {}
listing = [file for file in os.listdir(path) if file.endswith('csv')]
for each_file in listing:
    full_file_name = os.path.join(path, each_file)
    print("current file is: " + full_file_name)
    data_frame = pandas.read_csv(full_file_name)
    data_frames[each_file] = data_frame

for name, df in data_frames.items():
    print(name)
    print(df.head())
# endregion

# region prints the contents of every Python file
listing = os.listdir(path)
for i in range(len(listing)):
    file_name = listing[i]
    if file_name.endswith('py'):
        print("------- File {0} ---------".format(file_name))
        with open(os.path.join(path, file_name)) as current_file:
            file_text = current_file.read()
            file_as_list = file_text.splitlines()
            current_line_count = 0
            for line in file_as_list:
                current_line_count += 1
                print(f"{current_line_count} {line}")
                if current_line_count >= 5:
                    break
# endregion


# region handle multiple file types
def handle_file(current_path, file_to_handle):
    current_file_name = os.path.join(current_path, file_to_handle)
    print(f"------- File {current_file_name} ---------")
    if file_to_handle.endswith('.csv'):
        current_data_frame = pandas.read_csv(current_file_name)
        print(current_data_frame.head())
    elif file_to_handle.endswith('.py'):
        with open(os.path.join(path, current_file_name)) as source_file:
            source_text = source_file.read()
            source_as_list = source_text.splitlines()
            line_count = 0
            for source_line in source_as_list:
                line_count += 1
                print(f"{line_count} {source_line}")
                if line_count >= 5:
                    break
    else:
        print(f"Cannot handle file {file_to_handle}")


listing = [file for file in os.listdir(path) if file.endswith('.csv') or file.endswith('.py')]
listing = sorted(listing, key=str.lower)
for each_file in listing:
    handle_file(path, each_file)

# endregion
