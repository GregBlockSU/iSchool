from dataclasses import dataclass, field
from typing import List
from Point import Point
from abc import ABC, abstractmethod
from Shape import * 
from PIL import Image, ImageDraw

class Drawable(ABC):
    
    @abstractmethod
    def draw(self, imageDraw):
        pass

    @staticmethod
    def flip(lowerLeft : Point, upperRight : Point):
        return [lowerLeft.get_x(), upperRight.get_y(), upperRight.get_x(), lowerLeft.get_y()]

@dataclass
class DrawableLineShape(LineShape, Drawable):
    def __init__(self, point1: Point, point2: Point):
        super().__init__(point1, point2)

    def draw(self, imageDraw):
        imageDraw.line((self._point1.get_x(), self._point1.get_y(), 
                        self._point2.get_x(), self._point2.get_y()), 
                        fill=("black"), width=2)

@dataclass
class DrawablePolyLineShape(PolyLineShape, Drawable):
    def __init__(self, points: List[Point]):
        self.set_points(points)

    def draw(self, imageDraw):
        pointList = [(point.get_x(), point.get_y()) for point in self._points]

        imageDraw.line((pointList), fill=("blue"), width=2)

@dataclass
class DrawableRectangleShape(RectangleShape, Drawable):
    def __init__(self, lowerLeft: Point, width: int, height: int):
        self.set_size(lowerLeft, width, height)

    def draw(self, imageDraw):
        imageDraw.rectangle([self._lowerLeft.get_x(), self._lowerLeft.get_x(), 
                                    self._lowerLeft.get_x() + self._width, 
                                    self._lowerLeft.get_x() + self._height],
                                    fill=("green"), width=2)

@dataclass
class DrawableSquareShape(DrawableRectangleShape, Drawable):
    def __init__(self, upperLeft: Point, size: int):
        super().__init__(upperLeft, size, size)

@dataclass
class DrawableEllipseShape(EllipseShape, Drawable):
    def __init__(self, upperLeft: Point, width: int, height: int):
        super().__init__(upperLeft, width, height)

    def draw(self, imageDraw):

        imageDraw.ellipse([self._lowerLeft.get_x(), self._lowerLeft.get_x(), 
                                    self._lowerLeft.get_x() + self._width, 
                                    self._lowerLeft.get_x() + self._height],
                                    fill=("pink"), width=2)

