stock = {"banana": 6, "apple": 0, "orange": 32, "pear": 15}
prices = {"banana": 4, "apple": 2, "orange": 1.5, "pear": 3}

print(f"The value of the stock dictionary at the key 'orange' is '{stock['orange']}'")
stock['cherry'] = 50
prices['cherry'] = 2.7

print('The stock dictionary')
print(stock)

print('The prices dictionary')
print(prices)

print("print the stock list using for loop")
for k, v in stock.items():
    print(f"Item '{k}' has {v} items in stock")

print("print the stock list using lambda")
list(map(lambda k:print(f"Item '{k}' has '{stock[k]} items in stock"), stock))

groceries = ['apple', 'banana', 'pear']
print(groceries)

total_in_stock = 0
for item in groceries:
    total_in_stock += stock[item]
print(f"Total groceries in stock using a for loop: {total_in_stock}")
total_in_stock = sum(map(lambda item: stock[item], groceries))
print(f"Total groceries in stock using lambda: {total_in_stock}")

total_value = 0.0
for item in stock:
    total_value += float(stock[item]) * prices[item]
print(f"Total value of prices and stock using for loop: {total_value}")

total_value = sum(map(lambda item: prices[item] * float(stock[item]), stock))
print(f"Total value of prices and stock using lambda: {total_value}")
total_value =sum(prices[item] * stock[item] for item in prices)
print(f"Total value of prices and stock using sum: {total_value}")



