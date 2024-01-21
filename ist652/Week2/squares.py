def squares(n=10):
    print(f"Generating squares from 1 to {n ** 2}")
    for i in range(1, n + 1):
        yield i ** 2

call_squares = squares(8)
for x in call_squares:
    print(x, end=" ")