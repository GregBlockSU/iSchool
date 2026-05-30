# calulates the factorial of a number
def factorial(n):
    if(n <= 1):
        return 1
    else:
        return(n*factorial(n-1))

# prompt the user and be sure the user supplies a positive integer
nterms = int(input("Enter an integer: "))
if nterms <= 0:
   print("A positive integer is required")
else:
   print(f"The factorial of {nterms} is {factorial(nterms)}")