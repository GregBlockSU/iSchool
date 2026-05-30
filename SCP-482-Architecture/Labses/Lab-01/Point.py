from dataclasses import dataclass

@dataclass
class Point:
    x: int
    y: int

    def __init__(self, x: int, y: int):
        self.x = x
        self.y = y

    def show(self):
        print(f"x={self.x}, y={self.y}")

lowerLeft = Point(0, 0)
lowerLeft.show()
print(f"{lowerLeft.x}")
lowerLeft.y = -1