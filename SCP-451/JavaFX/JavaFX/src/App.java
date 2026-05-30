package JavaFX.src;

import javafx.application.Application;
import javafx.application.Platform;
import javafx.geometry.*;
import javafx.event.ActionEvent;
import javafx.scene.*;
import javafx.scene.control.*;
import javafx.scene.image.*;
import javafx.scene.layout.GridPane;
import javafx.stage.Stage;

// note that HelloFX extends the Application class
public class App extends Application {

    // the start method is called called by the launch method
    @Override
    public void start(Stage primaryStage) {

        // create the scene controls
        String javaVersion = System.getProperty("java.version");
        String javafxVersion = System.getProperty("javafx.version");
        Label textLabel = new Label("JavaFX " + javafxVersion + "/ Java " + javaVersion);
        Button okButton = new Button("OK");
        ImageView imageViewO = new ImageView(new Image("o.png"));
        ImageView imageViewX = new ImageView(new Image("x.png"));

        // add an event handler to the OK button - note use of lambda expression
        okButton.setOnAction((ActionEvent event) -> {
            Platform.exit();
        });

        // create a grid pane, configure it and add the control
        GridPane gridPane = new GridPane();
        gridPane.setPadding(new Insets(10, 10, 10, 10));
        gridPane.setVgap(5); 
        gridPane.setHgap(5); 
        gridPane.setAlignment(Pos.CENTER);         
        gridPane.add(textLabel, 0, 0);
        gridPane.add(imageViewO, 0, 1);
        gridPane.add(imageViewX, 1, 1);
        gridPane.add(okButton, 0, 3);

        // add the grid pane to the scene and configure the stage
        Scene openingScene = new Scene(gridPane, 320, 240);
        primaryStage.setScene(openingScene);
        primaryStage.setTitle("JavaFX Application");
        primaryStage.show();
    }

    // the static main method calls the overridden launch method
    public static void main(String[] args) {
        launch(args);
    }
}