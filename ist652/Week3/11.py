def print_it(examples):
    for x in examples:
        if len(x) >= 3 and x[0] == x[-1]:
            print(x)

examples = ['abab', 'xyz', 'aa', 'x', 'bcb']
print_it(examples)
examples = ['', 'x', 'xy', 'xyx', 'xx']
print_it(examples)
examples = ['aaa', 'be', 'abc', 'hello']
print_it(examples)