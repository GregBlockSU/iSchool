import javafx.application.Application;
import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.layout.VBox;
import javafx.scene.layout.HBox;
import javafx.geometry.Pos;
import javafx.geometry.Insets;
import javafx.scene.control.Label;
import javafx.scene.control.Button;
import javafx.scene.control.RadioButton;
import javafx.scene.control.CheckBox;
import javafx.scene.control.ListView;
import javafx.scene.control.SelectionMode;
import javafx.scene.control.ToggleGroup;
import javafx.collections.ObservableList;

/**
   Conference Registration System
*/

public class ConferenceRegistration extends Application
{
   public static void main(String[] args)
   {
      // Launch the application.
      launch(args);
   }
   
   @Override
   public void start(Stage primaryStage)
   {
      // Registration radio buttons
      RadioButton genRegRadioButton = new RadioButton("General Registration");
      RadioButton stuRegRadioButton = new RadioButton("Student Registration");
      genRegRadioButton.setSelected(true);
      ToggleGroup radioGroup = new ToggleGroup();
      genRegRadioButton.setToggleGroup(radioGroup);
      stuRegRadioButton.setToggleGroup(radioGroup);
      VBox regVBox = new VBox(10, genRegRadioButton, stuRegRadioButton);
      
      // Opening night dinner
      CheckBox dinnerCheckBox = new CheckBox("Opening Night Dinner");
      
   
      // Build the preconference workshop ListView.
      ListView<String> workshopListView = new ListView<>();
      workshopListView.setPrefSize(200, 100);
      workshopListView.getSelectionModel().setSelectionMode(SelectionMode.MULTIPLE);
      workshopListView.getItems().addAll("Introduction to E-commerce",
                                         "The Future of the Web",
                                         "Advanced Java Programming",
                                         "Network Security");
      
      // Label to prompt the user to select a workshop
      Label workshopPromptLabel = new Label("Select an Option Workshop");
      VBox workshopVBox = new VBox(10, workshopPromptLabel, workshopListView);
      
      // Create the output label for total cost.
      Label costDescriptor = new Label("Cost:");
      Label costOutputLabel = new Label("0.00");
      HBox costHBox = new HBox(10, costDescriptor, costOutputLabel);
      costHBox.setAlignment(Pos.CENTER);
      
      // Create the Calculate button.
      Button calcButton = new Button("Calculate Cost");
      
      // Register event handler for the button
      calcButton.setOnAction(event ->
      {
         double totalCharges = 0.0;
         
         // Registration
         if (genRegRadioButton.isSelected())
         {
            totalCharges += 895.0;
         }
         else
         {
            totalCharges += 495.0;
         }
         
         // Opening night dinner
         if (dinnerCheckBox.isSelected())
         {
            totalCharges += 30.0;
         }
                  
         // Get the ObservableList of selected workshops.
         ObservableList<String> workshops = workshopListView.getSelectionModel().getSelectedItems();
         for (String str : workshops)
         {
            if (str.equals("Introduction to E-commerce"))
               totalCharges += 295.0;
            
            else if (str.equals("The Future of the Web"))
               totalCharges += 295.0;
               
            else if (str.equals("Advanced Java Programming"))
               totalCharges += 395.0;
               
            else if (str.equals("Network Security"))
               totalCharges += 395.0;
         }
         
         
         // Display the charges.
         costOutputLabel.setText(String.format("%,.2f", totalCharges));
      });
      
      // Put everything into a VBox
      VBox mainVBox = new VBox(10, regVBox, dinnerCheckBox, workshopVBox, costHBox, calcButton);
      mainVBox.setAlignment(Pos.CENTER);
      mainVBox.setPadding(new Insets(10));
      
      // Add the main VBox to a scene.
      Scene scene = new Scene(mainVBox);
      
      // Set the scene to the stage aand display it.
      primaryStage.setScene(scene);
      primaryStage.show();
   }
}