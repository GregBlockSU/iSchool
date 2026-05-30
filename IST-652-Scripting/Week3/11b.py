def print_with_filter(examples):
    for x in filter(lambda x: len(x) >= 3 and x[0] == x[-1], examples):
        print(x)

def print_with_loop(examples):
    for x in examples:
        if len(x) >= 3 and x[0] == x[-1]:
            print(x)

def print_both(examples):
    print('\nUsing filter')
    print_with_filter(examples)
    print('\nUsing loop')
    print_with_loop(examples)

examples = ['abab', 'xyz', 'aa', 'x', 'bcb']
print_both(examples)
examples = ['', 'x', 'xy', 'xyx', 'xx']
print_both(examples)
examples = ['aaa', 'be', 'abc', 'hello']
print_both(examples)
