nterms = int(input("Enter an integer: "))
if nterms <= 0:
    print("A positive integer is required")
else:
    n, fact = nterms, 1
    while (n > 0):
        fact = fact * n
        n = n - 1
    print(f"The factorial of {nterms} is {fact}")