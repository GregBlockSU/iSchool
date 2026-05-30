import java.io.*;

public class Circle extends Shape {
    private int radius;
    public Circle(int x, int y, int radius) {
        super(x, y);
        this.radius = radius;
    }
    @Override
    public void draw() {
        // draw the circle
    }

    @Override
    public double getArea() {
        return Math.PI * radius * radius;



  
    }
}