def fib(n): 
    if n < 0: 
        print(f'Invalid input {n}') 
        return -1
    # the first number in the fibonacci series is 0...
    elif n == 1: 
        return 0
    # the second number in the fibonacci series is 1 
    elif n == 2: 
        return 1
    else: 
        return fib(n - 1) + fib(n - 2) 
  
def main():
    for i in range(1, 11):
        print(f'The fibonacci value of {i} is {fib(i)}')

    print(fib(-10))
  
main()