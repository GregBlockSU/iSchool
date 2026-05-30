import javafx.application.Application;
import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.VBox;
import javafx.scene.layout.HBox;
import javafx.scene.layout.GridPane;
import javafx.geometry.Pos;
import javafx.geometry.Insets;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import java.util.Random;

/**
   Tic Tac Toe Simulator
*/

public class TicTacToe extends Application
{
   // Named constants for array sizes
   private final int ROWS = 3;	// Number of game board rows
   private final int COLS = 3;	// Number of game board columns
   private final int SIZE = 2;	// Number of Image objects
   
   // Create a two-dimensional array of ints  
   // to represent the game board in memory.
   private int[][] gameBoardMemory = new int[ROWS][COLS];
      
   // Create a two-dimensional array of  
   // ImageView components to represent  
   // the visible game board.
   private ImageView[][]gameBoardImages = new ImageView[ROWS][COLS];
   
   // Array of Image objects
   Image[] images = new Image[SIZE];
   
   // Create a Label for instructions and game results.
   Label outputLabel = new Label("Click the New Game button to play.");

   public static void main(String[] args)
   {
      // Launch the application.
      launch(args);
   }
   
   @Override
   public void start(Stage primaryStage)
   {     
      // Populate the ImageView array with blank images.
      for (int row = 0; row < ROWS; row++)
      {
         for (int col = 0; col < COLS; col++)
         {
            gameBoardImages[row][col] = new ImageView("BlankXO.png");
         }
      }
      
      // Create a GridPane and populate it with the ImageViews.
      GridPane gridpane = new GridPane();
      for (int row = 0; row < ROWS; row++)
      {
         for (int col = 0; col < COLS; col++)
         {
            gridpane.add(gameBoardImages[row][col], col, row);
         }
      }
            
      // Set the HGap and VGap spacing.
      gridpane.setHgap(10);
      gridpane.setVgap(10);
   
      // Load the X and O images.
      images[0] = new Image("O.png");
      images[1] = new Image("X.png");
                  
      // New Game Button
      Button newGameButton = new Button("New Game");
      
      // Register the event handler for the New Game Button
      newGameButton.setOnAction(e ->
      {
         // Display a new game board.
         displayGameBoard();

         // Determine the winner.
         determineWinner();
      });
      
      // Put everything into a VBox
      VBox mainVBox = new VBox(10, gridpane, outputLabel, newGameButton);
      mainVBox.setAlignment(Pos.CENTER);
      mainVBox.setPadding(new Insets(10));
      
      // Add the main VBox to a scene.
      Scene scene = new Scene(mainVBox);
      
      // Set the scene to the stage aand display it.
      primaryStage.setScene(scene);
      primaryStage.show();
   }
   
   // The displayGameBoard method displays the game board.
   private void displayGameBoard()
   {
      int winner = -1;   // Winner flag
      int count = 0;     // Loop counter
      
      // Initialize a new game board.
      for (int row = 0; row < ROWS; row++)
      {
         for (int col = 0; col < COLS; col++)
         {
            // Set the game element to -1.
            gameBoardMemory[row][col] = -1;

            // Set the game board image to display.
            gameBoardImages[row][col].setImage(new Image("BlankXO.png"));
         }
      }
   
      // Random number generator
      Random rand = new Random();
      
      // Play the game.
      while (winner == -1 && count < (ROWS * COLS))
      {
         // Randomly select a blank cell
         int r = rand.nextInt(ROWS);
         int c = rand.nextInt(COLS);
         
         // If that cell hasn't been played, play it.
         if (gameBoardMemory[r][c] == -1)
         {
            // Generate a random number.
            int val = rand.nextInt(SIZE);

            // Set the game board value in memory.
            gameBoardMemory[r][c] = val;

            // Set the game board image to display.
            gameBoardImages[r][c].setImage(images[val]);
            
            // Increment the counter.
            count++;
            
            // Check for a winner.
            winner = determineWinner();
         }
      }
   }
   
   // The determineWinner method determines the winner.
   private int determineWinner()
   {
      int winner = -1;
      
      // Determine if player X wins.
      if ((gameBoardMemory[0][0] == 1 &&  // Check the first row.
           gameBoardMemory[0][1] == 1 && 
           gameBoardMemory[0][2] == 1) 
           ||
          (gameBoardMemory[1][0] == 1 &&  // Check the second row.
           gameBoardMemory[1][1] == 1 &&
           gameBoardMemory[1][2] == 1)
           ||
          (gameBoardMemory[2][0] == 1 &&  // Check the third row.
           gameBoardMemory[2][1] == 1 &&
           gameBoardMemory[2][2] == 1)
           ||
          (gameBoardMemory[0][0] == 1 &&  // Check the first column.
           gameBoardMemory[1][0] == 1 &&
           gameBoardMemory[2][0] == 1)              
           ||
          (gameBoardMemory[0][1] == 1 &&  // Check the second column.
           gameBoardMemory[1][1] == 1 &&
           gameBoardMemory[2][1] == 1)              
           ||
          (gameBoardMemory[0][2] == 1 &&  // Check the third column.
           gameBoardMemory[1][2] == 1 &&
           gameBoardMemory[2][2] == 1)              
           ||
          (gameBoardMemory[0][0] == 1 &&  // Check diagonally from 
           gameBoardMemory[1][1] == 1 &&  // top-left to bottom-right.
           gameBoardMemory[2][2] == 1)
           ||
          (gameBoardMemory[0][2] == 1 &&  // Check diagonally from 
           gameBoardMemory[1][1] == 1 &&  // top-right to bottom-left.
           gameBoardMemory[2][0] == 1))
      {
         // Player X is the winner.
         outputLabel.setText("X wins!");
         winner = 1;
      }
      
      // Determine if player O wins.
      else if ((gameBoardMemory[0][0] == 0 &&  // Check the first row.
                gameBoardMemory[0][1] == 0 && 
                gameBoardMemory[0][2] == 0) 
                ||
               (gameBoardMemory[1][0] == 0 &&  // Check the second row.
                gameBoardMemory[1][1] == 0 &&
                gameBoardMemory[1][2] == 0)
                ||
               (gameBoardMemory[2][0] == 0 &&  // Check the third row.
                gameBoardMemory[2][1] == 0 &&
                gameBoardMemory[2][2] == 0)
                ||
               (gameBoardMemory[0][0] == 0 &&  // Check the first column.
                gameBoardMemory[1][0] == 0 &&
                gameBoardMemory[2][0] == 0)              
                ||
               (gameBoardMemory[0][1] == 0 &&  // Check the second column.
                gameBoardMemory[1][1] == 0 &&
                gameBoardMemory[2][1] == 0)              
                ||
               (gameBoardMemory[0][2] == 0 &&  // Check the third column.
                gameBoardMemory[1][2] == 0 &&
                gameBoardMemory[2][2] == 0)              
                ||
               (gameBoardMemory[0][0] == 0 &&  // Check diagonally from 
                gameBoardMemory[1][1] == 0 &&  // top-left to bottom-right.
                gameBoardMemory[2][2] == 0)
                ||
               (gameBoardMemory[0][2] == 0 &&  // Check diagonally from 
                gameBoardMemory[1][1] == 0 &&  // top-right to bottom-left.
                gameBoardMemory[2][0] == 0))
      {
         // Player O is the winner.
         outputLabel.setText("O wins!");
         winner = 0;
      }
      
      // The game was a tie.
      else
      {
         outputLabel.setText("The game was a tie.");
         winner = -1;
      }
      
      return winner;
   }
}