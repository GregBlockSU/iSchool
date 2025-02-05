#for item in [1,2,3,4,5,6]:
#    print(item** 2)
#print('done')

# here is where we define a function to square values
#def squares(n=10):
#    print(f"Generating squares from 1 to {n ** 2}")
#    for i in range(1, n + 1):
#        yield i ** 2

def calc_pmt(int, nper, initial_amount):
    pmt = int * initial_amount / nper
    return pmt

def squares2():
    nums = [1,2,3,4,5,6]
    for i in nums:
        i=i**2
        print(i)
    return 1

res = calc_pmt(.10, 360, 1000000)
print(res)

#call_squares = squares(8)
#for x in call_squares:
#    print(x, end=" ")