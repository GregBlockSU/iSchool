base = int(input('Enter the base integer:'))
exp = int(input('Enter the base exponent:'))

result = 1
while exp > 0:
	result = result * base
	exp = exp - 1
	print(f'round {exp} is {result}')

print(f'{base} ^ {exp} is {result}')