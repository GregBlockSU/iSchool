print('number example')
num = 7
num = num * num
print(num)

print('conditional expression example')

ubound = 50
if num < ubound:
    print('{num} is less than {ubound}')

print('for loop example')
num = 6
for index in range (10):
    num = num * 6

print(num)

print('array example')

dwords = ['we', 'hold', 'these', 'truths', 'to', 'be', 'self-evident', 'that', 'all', 'men', 'are', 'created', 'equal']

str = ''
for dltr in dwords:
    str = str + dltr + ' '

print(str)

print('truths' in dwords)
print('constitution' in dwords)

print('error examples')

#str + num
str
print('hello, world')