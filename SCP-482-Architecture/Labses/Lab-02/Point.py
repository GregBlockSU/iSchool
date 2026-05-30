from dataclasses import dataclass

@dataclass
class Point:
    _x: int
    _y: int

    def __init__(self, x: int, y: int):
        self.set_xy(x, y)

    def show(self):
        print(f"x={self._x}, y={self._y}")

    # x getter methods
    def get_x(self):
        return self._x

    # setter method
    def set_x(self, x : int):
        if x < 0:
            raise ValueError("x cannot be less than zero")
        self._x = x

    # getter method
    def get_y(self):
        return self._y

    # setter method
    def set_y(self, y : int):
        if y < 0:
            raise ValueError("y cannot be less than zero")
        self._y = y

    # xy setter method
    def set_xy(self, x, y):
        if x < 0 or y < 0:
            raise ValueError("x and y cannot be less than zero")
        self._x = x
        self._y = y

    @staticmethod
    def matches(point1, point2):
        return point1.get_x() == point2.get_x() and point1.get_y() == point2.get_y()

    @staticmethod
    def lessthan(point1, point2):
        return point1.get_x() < point2.get_x() and point1.get_y() < point2.get_y()

    # getter method
    def get_point1(self):
        return self._point1

lowerLeft = Point(10, 10)
#lowerLeft.set_x(-100)
lowerLeft.show()
print(f"the x value is {lowerLeft.get_x()}")
print(f"{lowerLeft.get_x}")
lowerLeft = Point(10, 10)
upperRight = Point(100, 100)
print(f"lowerLeft matches upperRight: {Point.matches(lowerLeft, upperRight)}")
#lowerLeft.set_y(-1)
