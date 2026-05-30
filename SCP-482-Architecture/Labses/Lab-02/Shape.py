from dataclasses import dataclass
from Point import Point

@dataclass
class LineShape:
    _point1: Point
    _point2: Point

    def __init__(self, point1: Point, point2: Point):
        self.set_points(point1, point2)
 
    def get_point1(self):
        return self._point1

    # point1    setter method
    def set_point1(self, point1: Point):
        if Point.matches(self._point2, point1):
            raise ValueError("point1 cannot match point2")
        self._point1 = point1

    # point1 getter method
    def get_point2(self):
        return self._point2

    # point2 setter method
    def set_point2(self, point2: Point):
        if Point.matches(self._point1, point2):
            raise ValueError("point1 cannot match point2")
        self._point2 = point2

    # point1, point2 setter method
    def set_points(self, point1: Point, point2: Point):
        if Point.matches(point1, point2):
            raise ValueError("point1 cannot match point2")
        self._point1 = point1
        self._point2 = point2

    def show(self):
        print(f"point1: {self._point1}, point2: {self._point2}")

#lineShape = LineShape(Point(10, 10), Point(100, 100))
#lineShape.show()
#lineShape.set_point1(lineShape.get_point2())
