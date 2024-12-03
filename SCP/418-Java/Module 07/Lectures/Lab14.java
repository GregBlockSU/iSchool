import javafx.application.Application;
import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.layout.Pane;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.shape.Line;
import javafx.scene.shape.Circle;

public class Lab14 extends Application
{
   public static void main(String[] args)
   {
      launch(args);
   }
   
   @Override
   public void start(Stage primaryStage)
   {
      // Constants for the scene size
      final double SCENE_WIDTH = 520.0;
      final double SCENE_HEIGHT = 520.0;
      
      // Constants for each square's XY coordinates
      final int X1 = 10, Y1 = 10;      // Square #1
      final int X2 = 60, Y2 = 60;      // Square #1
      final int X3 = 110, Y3 = 110;    // Square #3
      
      // Constants for each square's width and height
      final int WIDTH1 = 500, HEIGHT1 = 500; // Square #1
      final int WIDTH2 = 400, HEIGHT2 = 400; // Square #2
      final int WIDTH3 = 300, HEIGHT3 = 300; // Square #3
      
      // Constants for the circle's geometry
      final int CENTER_X = 260, CENTER_Y = 260, RADIUS = 150;
      
      // Create square #1
      Rectangle square1 = new Rectangle(X1, Y1, WIDTH1, HEIGHT1);
      square1.setStroke(Color.BLACK);
      square1.setFill(null);
      
      // Create square #2
      Rectangle square2 = new Rectangle(X2, Y2, WIDTH2, HEIGHT2);
      square2.setStroke(Color.BLACK);
      square2.setFill(null);
      
      // Create square #3
      Rectangle square3 = new Rectangle(X3, Y3, WIDTH3, HEIGHT3);
      square3.setStroke(Color.BLACK);
      square3.setFill(null);
      
      // Create the diagonal lines
      Line line1 = new Line(X1, Y1, X3, Y3);
      Line line2 = new Line(X1 + WIDTH1, Y1, X3 + WIDTH3, Y3);
      Line line3 = new Line(X1, Y1 + HEIGHT1, X3, Y3 + HEIGHT3);
      Line line4 = new Line(X1 + WIDTH1, Y1 + HEIGHT1, X3 + WIDTH3, Y3 + HEIGHT3);
      
      // Create the circle.
      Circle circle = new Circle(CENTER_X, CENTER_Y, RADIUS);
      
      // Add the nodes to a Pane.
      Pane pane = new Pane(square1, square2, square3, line1, line2, line3, line4, circle);
      
      // Create a Scene and display it.
      Scene scene = new Scene(pane, SCENE_WIDTH, SCENE_HEIGHT);
      primaryStage.setScene(scene);
      primaryStage.show();
   }
}
