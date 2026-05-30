base = int(input('Enter the base integer:'))
exp = int(input('Enter the base exponent:'))

result = 1
for x in range(exp):
	result = result * base
	print(f'round {x} is {result}')

print(f'{base} ^ {exp} is {result}')