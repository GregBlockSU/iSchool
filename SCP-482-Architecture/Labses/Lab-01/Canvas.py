from dataclasses import dataclass, field
from typing import List
from Point import Point

@dataclass
class Canvas:
    lowerLeft: Point
    upperRight: Point
    shapes: list = field(default_factory=list)

    def __init__(self, lowerLeft: Point, upperRight: Point):
        self.lowerLeft = lowerLeft
        self.upperRight = upperRight
        self.shapes = []
    
    def show(self):
        print(f"lowerLeft: {self.lowerLeft}, upperRight: {self.upperRight}")
        for shape in self.shapes:
            print(shape)

    def addShape(self, point: Point):
        self.shapes.append(point)



mainCanvas = Canvas(Point(0, 0), Point(500, 500)) 
mainCanvas.addShape(Point(250, 250))
mainCanvas.show()
