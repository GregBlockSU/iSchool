
import java.util.Scanner;   // explicitly imports a class
import java.util.*;         // wildcard import for all classes in the package
import java.io.*;

// Rectangle (subclass) inherits from Shape (superclass)
public class Rectangle extends Shape {
}

    private double length;
    private double width;

    private static int numberOfSides = 4;
    /**
     The setLength method stores a value in the
    length field.
    @param len The value to store in length.
  */
  public void setLength(double len) {
      length = len;

int[] daysOfMonth = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

// two dimensional array -- the first size declaration is the number
// of rows, the second is the number of columns
int ROWS = 3;
int COLUMNS = 4;
double[][] scores = new double[ROWS][COLUMNS];

// add some scores to the scores array
scores[0][0] = 25; // first row, first column
scores[0][1] = 30; // first row, second column
scores[1][0] = 0;   // second row, first column

// create an instance of a Rectangle object, and call the setCenter
// method, defined in the Shape superclass
Rectangle rect = new Rectangle(4, 5);
rect.setCenter(0, 0);

// display the contents of the scores array
for (int row = 0; row < 3; row++) {
  for (int col = 0; col < 4; col++) {
    System.out.println(scores[row][col]);
  }
}

// calculate the area based on length and width
public static double getArea(double len, double wid) {

    // create a rectangle and resize it
    Rectangle rect = new Rectangle(11, 14);
    Rectangle newRect = Rectangle.resizeRectangle(rect, .5);

    return len * wid;
}

// derived class calling the non-default constructor of the base class
public Rectangle(int x, int y) {
    super(x, y);
}

// the setCenter method in the derived class overrides the base class version
@Override
public void setCenter(int x, int y) {
    if (x - width / 2 >= 0) {
        super.setCenter(x, y);
    } else {
        // throw an error
    }
}

@Override
public void draw() {

}

// This method will not compile!
public void displayFile(String name)
{
   // Open the file.
   File file = new File(name);
   Scanner inputFile = new Scanner(file);
   // Read and display the file's contents.
   while (inputFile.hasNext())
   {
     System.out.println(inputFile.nextLine());
   }
   // Close the file.
   inputFile.close();
}

public static Rectangle resizeRectangle(Rectangle source, double multiplier) {
    Rectangle target = new Rectangle();

    // the source parameter is 
    target.setLength(source.getLength() * multipler);
    target.setWidth(source.getWidth() * multiplier);
    return target;

// try opening the file; this can generate a FileNotFoundException
// exception
try {
  File file = new File ("MyFile.txt");
  Scanner inputFile = new Scanner(file);
} catch (FileNotFoundException e) {
    // the code enters here if the FileNotFoundException occurs; note
    // that the parameter e is the name of the exception object
  System.out.println("File not found - " + e.getMessage());
} finally {
    System.out.println("All done");
}

int number;
String str = "not a number";
try
{
   number = Integer.parseInt(str);
}
catch (Exception e)
{
   System.out.println("The following error occurred: " + e.getMessage());
}




    Rectangle first = new Rectangle(12, 14);
    Rectangle second = new Rectangle(13, 11);

    boolean wrong = first == second;        // compares the references
    boolean same = first.equals(second);    // compares the values

    Drawable emptyShape = ()-> {};

    ArrayList<Shape> canvas = new ArrayList<>;
    canvas.add(new Rectangle(0, 0, 12, 21));
    canvas.add(new Circle(0, 0, 20));
    canvas.add(new Square(0, 0, 14));

    for(Shape shape : canvas) {
        shape.draw(); // calls Rectangle, Circle and Square.draw
    }
}



int numberOfSides = Rectangle.numberOfSides;

// call the getArea static method
double len = 12.4, wid = .12l
double area = Rectangle.getArea(len, wid);

// declare an array with three rows and three columns.
int[][] numbers = { {1, 2, 3}, {4, 5, 6}, {7, 8, 9} };
// row 0    {1, 2, 3}
// row 1    {4, 5, 6}
// row 2    {7, 8, 9}

// copy firstArray to secondArray
int[] firstArray = {5, 10, 15, 20, 25 };
int[] secondArray = new int[5];
for (int i = 0; i < firstArray.length; i++) {
  secondArray[i] = firstArray[i];
}
// copies the reference, not the array
int[] thirdArray = secondArray;


int[] firstArray = { 2, 4, 6, 8, 10 };
int[] secondArray = { 2, 4, 6, 8, 10 };

boolean equals = compareArrays(firstArray, secondArray);
  }

  public static boolean compareArrays(int[] firstArray, int[] secondArray) {
    boolean arraysEqual = true;    

    // First determine whether the arrays are the same size.
    if (firstArray.length != secondArray.length) {
        arraysEqual = false;
    }

    // Next determine whether the elements contain the same data.
    int i = 0;
    while (arraysEqual && i < firstArray.length) {
        if (firstArray[i] != secondArray[i]) {
            arraysEqual = false;
        }
        i++;
    }
    return arraysEqual;
}

int[] numbers1;                 // declare a variable that can reference an array
int[] numbers2 = new int[6];    // declare a variable and assign it the address
                                // of an array

  }
    /**
     The getLength method returns a Rectangle
    object's length.
    @return The value in the length field.
  */
  public double getLength() {
     return length;
  }
  
add(int, int)       // the add method is overloaded and the compiler
add(String, String) // chooses which version to bind based on parameters
    /**
      The getArea method returns a Rectangle
      object's area.
      @return The product of length times width.
   */
  public double getArea() {

    String name1 = new String("Hello, world");  // creates a string using the constructor
    String name2 = "Hello, world";              // creates a string from a literal

     return length * width;
  }
   /**
      Constructor
      @param len The length of the rectangle.
      @param w The width of the rectangle.
   */
  public Rectangle(int x, int y)
  {
     this.length = length;
     this.width = width;
  }

  // copy constructor
  public Rectangle (Rectangle other) {
      if (other != null) {
        width = other.getWidth();
        length = other.getLength();
      }
  }

  public static void main(string args) [

    // create two rectangles using the copy constructor
    Rectangle first = new Rectangle(18, .10);
    Rectangle second = new Rectangle(first);

    Rectangle kitchen = new Rectangle();
    Rectangle bedroom = new Rectangle();
    Rectangle den = new Rectangle();





String str = "Four score and seven years ago";
if (str.startsWith("Four")) {
    System.out.println("The string starts with Four.");
} else {
    System.out.println("The string does not start with Four.");
}

   

    
    Rectangle first = new Rectangle();
    Rectangle second = new Rectangle();

    first = second; // the first object is moved to the garbage collector
    second = null;  // the first object is moved to the garbage collector
}
