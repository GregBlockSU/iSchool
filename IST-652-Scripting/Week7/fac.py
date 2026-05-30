def recursive_factorial(n):
    if n == 0:
        return 1
    else:
        return n * recursive_factorial(n-1)


def iterative_factorial(n):        
    x = 1
    li = list(range(2, n+1))
    for each in li:
        x = x*each
    return x

def factorial(n):
    rec = recursive_factorial(n)
    iter = iterative_factorial(n)
    assert rec == iter
    return rec

li = list(range(1, 10))
for each in li:
    print(f"The factorial of {each} is {factorial(each)}")