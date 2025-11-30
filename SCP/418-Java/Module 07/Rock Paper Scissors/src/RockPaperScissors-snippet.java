import javafx.application.Application;
import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.control.Label;
import javafx.scene.layout.VBox;
import javafx.scene.layout.HBox;
import javafx.geometry.Pos;
import javafx.geometry.Insets;
import java.util.Random;

/**
 *  Rock Paper Scissors
 */

public class RockPaperScissors extends Application
{
   // Constants
   final int ROCK = 0;
   final int PAPER = 1;
   final int SCISSORS = 2;
   
   // Field for the computer's selection
   private int computer;
   
   public static void main(String[] args)
   {
      // Launch the application.
      launch(args);
   }
   
   @Override
   public void start(Stage primaryStage)
   {
      // Get the computer's selection.
      Random rand = new Random();
      computer = rand.nextInt(3);
      
      // Load the images.
      Image rockImage = new Image("rock.png");
      Image paperImage = new Image("paper.png");
      Image scissorsImage = new Image("scissors.png");

      // todo -fill out the rest of the form here

      // Register event handlers for the images
      rockIV.setOnMouseClicked(event ->
      {
         // Display selections
         compOutputLabel.setText(computerChoice());
         playerOutputLabel.setText("rock");
         
         // Display the winner
         if (computer == SCISSORS)
            title.setText("You win!");
         else if (computer == ROCK)
            title.setText("It's a tie.");
         else
            title.setText("Computer wins.");            
      });
      
      // todo - create handlers for paper and scissors      

      // Put the choice images in an HBox
      HBox gameHBox = new HBox(10, rockIV, paperIV, scissorsIV);
            
      // Put everything into a VBox
      VBox mainVBox = new VBox(10, title, gameHBox, compHBox, playerHBox);
      mainVBox.setAlignment(Pos.CENTER);
      mainVBox.setPadding(new Insets(10));
      
      // Add the main VBox to a scene.
      Scene scene = new Scene(mainVBox);
      
      // Set the scene to the stage and display it.
      primaryStage.setScene(scene);
      primaryStage.show();
   }
   
   // Returns the computer's choice, as a String
   private String computerChoice()
   {
      // todo - convert the computer int to a string
      return choice;
   }
}