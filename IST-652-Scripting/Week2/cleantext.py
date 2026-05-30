import re

def remove_punctuation(value):
    return re.sub("[!#?]", "", value)

clean_ops = [str.strip, remove_punctuation, str.title]

def clean_strings(strings, ops):
    result = []
    for value in strings:
        for func in ops:
            value = func(value)
        result.append(value)
    return result

states = ["   Alabama ", "Georgia!", "Georgia", "georgia", "FlOrIda",
          "south   carolina##", "West virginia?"]
clean_states = clean_strings(states, clean_ops)
for state, clean_state in zip(states, clean_states):
    print(f"{state} = {clean_state}")