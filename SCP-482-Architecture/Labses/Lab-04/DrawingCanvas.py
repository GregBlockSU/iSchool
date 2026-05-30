from dataclasses import dataclass, field
from typing import List
from Point import Point
from DrawableShape import * 
from Canvas import Canvas
from PIL import Image, ImageDraw

@dataclass
class DrawingCanvas(Canvas):

    def __init__(self, lowerLeft: Point, upperRight: Point):
        super().__init__(lowerLeft, upperRight)

    def draw(self, fileName):
        width = self.get_upperRight().get_x() - self.get_lowerLeft().get_x()
        height = self.get_upperRight().get_y() - self.get_lowerLeft().get_y()
        im = Image.new('RGB', (width, height), "white")
        imageDraw = ImageDraw.Draw(im)

        for shape in self.get_shapes():
            shape.draw(imageDraw)
            #print(shape.__class__)
        im.save(fileName)
        


# create the canvas
mainCanvas = DrawingCanvas(Point(0,0), Point(500,500))

# add elements to the canvas
mainCanvas.addShape(DrawableRectangleShape(Point(10, 10), 350, 300))
mainCanvas.addShape(DrawableEllipseShape(Point(100, 100), 100, 100))
mainCanvas.addShape(DrawableLineShape(Point(0, 500), Point(500, 0)))
mainCanvas.addShape(DrawablePolyLineShape([Point(0, 120), Point(450, 350), Point(180, 280)]))
mainCanvas.draw("mycanvas.jpg")
