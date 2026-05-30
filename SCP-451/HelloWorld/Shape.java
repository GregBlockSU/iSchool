import java.io.*;

public abstract class Shape implements Drawable, Serializable {
    private int x;
    private int y;

    // non-default constructor in the base class
    public Shape(int x, int y) {
        this.x = x;
        this.y = y;
    }
    public void setCenter(int x, int y) throws InvalidCoordinatesException{
        if (x < 0 || y < 0) {
            throw new InvalidCoordinatesException(x, y);
        }  
        this.x = x;
        this.y = y;

      // Create the stream objects.

                


    }

}