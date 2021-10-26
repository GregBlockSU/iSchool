import javafx.application.Application;
import javafx.scene.*;
import javafx.scene.layout.*;
import javafx.scene.paint.Color;
import javafx.scene.shape.*;
import javafx.scene.text.Text;
import javafx.stage.Stage;

// note that HelloFX extends the Application class
public class App extends Application {

    // the start method is called called by the launch method
    @Override
    public void start(Stage primaryStage) {
        // Constants for the scene size and margin
        final double SCENE_WIDTH = 320.0;
        final double SCENE_HEIGHT = 240.0;
        final double SHAPE_MARGIN = 20;

        // construct the rectangle edges
        Rectangle myRect = new Rectangle(SHAPE_MARGIN, SHAPE_MARGIN, SCENE_WIDTH - 2 * SHAPE_MARGIN, 
            SCENE_HEIGHT - 2 * SHAPE_MARGIN);

        myRect.setFill(Color.KHAKI);

        // create a diamond polygon
        Polygon myPoly = new Polygon(160, 20, 300, 120, 160, 220, 20, 120, 160, 20);
        myPoly.setFill(Color.BISQUE);

        // create a circle offset from center
        Circle myCircle = new Circle(SHAPE_MARGIN + SCENE_WIDTH / 2, SHAPE_MARGIN + SCENE_HEIGHT / 2, 50);
        myCircle.setFill(Color.ALICEBLUE);

        // create a text string, measure the size of the string, and center the string
        Text myText = new Text(SCENE_WIDTH / 2, SCENE_HEIGHT / 2, "JavaFX shapes");
        final double width = myText.getLayoutBounds().getWidth();
        myText.setX(SCENE_WIDTH / 2 - width / 2);

        // add the shapes to a collection, and add the collection to a scene
        Pane canvas = new Pane(myRect,myPoly, myCircle, myText);

        Scene scene = new Scene(canvas, SCENE_WIDTH, SCENE_HEIGHT);
        primaryStage.setScene(scene);
        primaryStage.setTitle("JavaFX shapes");
        primaryStage.show();        

    }

    // the static main method calls the overridden launch method
    public static void main(String[] args) {
        launch(args);
    }
}