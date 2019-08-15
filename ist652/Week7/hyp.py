import math

def calculate_hypotenuse(width, height):
    return math.sqrt(math.pow(width, 2) + math.pow(height, 2))

def prompt_for_sides():
    width = input("Enter width (nothing to exit):")
    if (width != ""):
        height = input("Enter height (nothing to exit):")

    if width=="" or height=="":
        return None, None

    width=int(width)
    height=int(height)
    return width, height

def main():
    while True:
        width,height = prompt_for_sides()
        if width is None:
            break

        hypotenuse = calculate_hypotenuse(width, height)
        print(f'The hypotenuse of width {width}, height {height} is {hypotenuse}')

main()