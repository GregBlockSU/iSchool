from dataclasses import dataclass, field
from typing import List
from Point import Point
from Shape import * 

@dataclass
class Canvas:
    _lowerLeft: Point
    _upperRight: Point
    _shapes: list[Shape] = field(default_factory=list)

    def __init__(self, lowerLeft: Point, upperRight: Point):
        self.set_points(lowerLeft, upperRight)
        self._shapes = []
    
    # lowerLeft getter method
    def get_lowerLeft(self):
        return self._lowerLeft

    # lowerLeft setter method
    def set_lowerLeft(self, lowerLeft: Point):
        if not Point.lessthan(self._lowerLeft, lowerLeft):
            raise ValueError("lowerLeft coordinates cannot equal or exceed upperRight")
        self._lowerLeft = lowerLeft

    # upperRight getter method
    def get_upperRight(self):
        return self._upperRight

    # point2 setter method
    def set_upperRight(self, upperRight: Point):
        if Point.matches(self._upperRight, upperRight):
            raise ValueError("lowerLeft coordinates cannot equal or exceed upperRight")
        self._upperRight = upperRight

    # point2 setter method
    def set_points(self, lowerLeft: Point, upperRight: Point):
        if Point.matches(lowerLeft, upperRight):
            raise ValueError("point1 cannot match point2")
        self._lowerLeft = lowerLeft
        self._upperRight = upperRight

    def show(self):
        print(f"lowerLeft: {self._lowerLeft}, upperRight: {self._upperRight}")
        for shape in self._shapes:
            shape.show()

    def addShape(self, shape: Shape):
        if not shape.outOfBounds(self._lowerLeft, self._upperRight):
            self._shapes.append(shape)


# create the canvas
mainCanvas = Canvas(Point(0, 0), Point(500, 500))

# add elements to the canvas
mainCanvas.addShape(LineShape(Point(10, 10), Point(50, 50)))
mainCanvas.addShape(PolyLineShape([Point(10, 10), Point(50, 50), Point(80, 80)]))
mainCanvas.addShape(RectangleShape(Point(10, 10), 50, 100))
mainCanvas.addShape(SquareShape(Point(10, 10), 75))
mainCanvas.show()
