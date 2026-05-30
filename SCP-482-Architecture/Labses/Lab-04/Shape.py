from dataclasses import dataclass, field
from typing import List
from Point import Point
from abc import ABC, abstractmethod

class Shape(ABC):

    @abstractmethod
    def outOfBounds(self, lowerLeft: Point, upperRight: Point):
        pass

    @abstractmethod
    def show(self):
        pass
    

@dataclass
class LineShape(Shape):
    _point1: Point
    _point2: Point

    def __init__(self, point1: Point, point2: Point):
        self.set_points(point1, point2)
 
    def get_point1(self):
        return self._point1

    # point1 setter method
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

    #override abstract method
    def show(self):
        print(f"point1: {self._point1}, point2: {self._point2}")

    # override abstract method
    def outOfBounds(self, lowerLeft: Point, upperRight: Point):
        return Point.lessthan(self._point1, lowerLeft) or Point.lessthan(self._point2, lowerLeft) or \
            Point.greaterthan(self._point1, upperRight) or Point.greaterthan(self._point2, upperRight)



@dataclass
class PolyLineShape(Shape):
    _lines: list[Point] = field(default_factory=list)

    def __init__(self, points: List[Point]):
        self.set_points(points)
 
    def get_points(self):
        return self._points

    # point1 setter method
    def set_points(self, points: Point):
        for point1 in points:
            for point2 in points:
                if False and Point.matches(point2, point1):
                    raise ValueError("point1 cannot match point2")
        self._points = points

    #override abstract method
    def show(self):
        for point in self._points:
            print(f"point: {point}")

    # override abstract method
    def outOfBounds(self, lowerLeft: Point, upperRight: Point):
        for point in self._points:
            if Point.lessthan(point, lowerLeft) or Point.greaterthan(point, upperRight):
                return True
        return False

@dataclass
class RectangleShape(Shape):
    _lowerLeft: Point
    _width: int
    _height: int

    def __init__(self, lowerLeft: Point, width: int, height: int):
        self.set_size(lowerLeft, width, height)
 
    def get_lowerLeft(self):
        return self._lowerLeft

    def get_upperRight(self):
        return Point(self._lowerLeft.get_x() + self._width, self._lowerLeft.get_y() + self._height)

   # upperLeft setter method
    def set_lowerLeft(self, lowerLeft: Point):
        self._lowerLeft = lowerLeft

    # width setter method
    def set_width(self, width: int):
        if width < 0:
            raise ValueError("width cannot be negative")
        self._width = width

    # width getter method
    def get_width(self):
        return self._width

    # height setter method
    def set_height(self, height: int):
        if height < 0:
            raise ValueError("width cannot be negative")
        self._height = height

    # height getter method
    def get_height(self):
        return self._height

    # point1, point2 setter method
    def set_size(self, lowerLeft: Point, width: int, height: int):
        if width < 0 or height < 0:
            raise ValueError("width and height cannot be negative")
        self._lowerLeft = lowerLeft
        self._width = width
        self._height = height

    #override abstract method
    def show(self):
        print(f"lowerLeft: {self._lowerLeft}, width: {self._width}, height: {self._height}")

    # override abstract method
    def outOfBounds(self, lowerLeft: Point, upperRight: Point):
        selfUpperRight = Point(self._lowerLeft.get_x() + self._width, self._lowerLeft.get_y() + self._height)
        return Point.lessthan(self._lowerLeft, lowerLeft) or Point.greaterthan(selfUpperRight, upperRight)

 
@dataclass
class SquareShape(RectangleShape):
    def __init__(self, upperLeft: Point, size: int):
        super().__init__(upperLeft, size, size)
 
@dataclass
class EllipseShape(RectangleShape):
    def __init__(self, upperLeft: Point, width: int, height: int):
        super().__init__(upperLeft, width, height)

#lineShape.show()
#lineShape.set_point1(lineShape.get_point2())
