import csv
from statistics import mean

# region CONSTANT declarations
STATES_FILE_NAME = 'states_data.tsv'
# endregion

# region function declarations

# open the file and copy each line to an array
def get_state_list(file_name):
    """ Retrieves the list of states from file file_name
    """
    my_state_list = []
    with open(file_name) as states_file:
        state_reader = csv.reader(states_file, dialect='excel', delimiter='\t')

        data_lines = ([line for line in state_reader if line[0].strip() != '' and not line[0].startswith('Data') and not line[0].startswith('*')])
        for data_line in data_lines:
            my_state_name, my_state_abbrev, my_postal_abbrev, my_area, my_pop = data_line[0], data_line[1], data_line[2], int(data_line[3].replace(',', '')), int(data_line[4].replace(',', ''))
            my_state_list.append([my_state_name, my_state_abbrev, my_postal_abbrev, my_area, my_pop])
    return my_state_list


def get_state_area_stats(my_state_list):
    """ Calculates the mean, min and max areas for the states
    """
    my_areas = (my_area for my_state_name, my_state_abbrev, my_postal_abbrev, my_area, my_pop in my_state_list)
    my_mean_area: int = mean(my_areas)
    my_areas = (my_area for my_state_name, my_state_abbrev, my_postal_abbrev, my_area, my_pop in my_state_list)
    my_min_area: int = min(my_areas)
    my_areas = (my_area for my_state_name, my_state_abbrev, my_postal_abbrev, my_area, my_pop in my_state_list)
    my_max_area: int = max(my_areas)
    return my_mean_area, my_min_area, my_max_area


def get_state_pop_stats(my_state_list):
    """ Calculates the mean, min and max populations for the states
    """
    my_pops = (my_pop for my_state_name, my_state_abbrev, my_postal_abbrev, my_area, my_pop in my_state_list)
    my_mean_pop: int = mean(my_pops)
    my_pops = (my_pop for my_state_name, my_state_abbrev, my_postal_abbrev, my_area, my_pop in my_state_list)
    my_min_pop: int = min(my_pops)
    my_pops = (my_pop for my_state_name, my_state_abbrev, my_postal_abbrev, my_area, my_pop in my_state_list)
    my_max_pop: int = max(my_pops)
    return my_mean_pop, my_min_pop, my_max_pop

# endregion


# region main code branch
# get the list of states from the TSV file
state_list = get_state_list(STATES_FILE_NAME )

# print out the list
for state_name, state_abbrev, postal_abbrev, area, pop in state_list:
    print(f"State  {state_name}, abbreviation {state_abbrev if state_abbrev != '' else 'blank'}, postal abbreviation {postal_abbrev if postal_abbrev != '' else 'blank'},  has area {area} and population {pop}")

mean_area, min_area, max_area = get_state_area_stats(state_list)
mean_pop, min_pop, max_pop = get_state_pop_stats(state_list)
# print statistics
print(f"There are {len(state_list)} listings")
print(f"The average, min and max areas are {mean_area}, {min_area}, and {max_area}")
print(f"The average, min and max populations are {mean_pop}, {min_pop}, and {max_pop}")

#end region
