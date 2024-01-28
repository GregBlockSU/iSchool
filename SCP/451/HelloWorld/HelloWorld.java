
// this is the HelloWorld sample program

import java.io.*;
import java.util.Scanner;  // Import the Scanner class
class HelloWorld {
// The compiler generates the following error:
// Unhandled exception type FileNotFoundException

public void printFile(String name) throws FileNotFoundException {
   File file = new File(name);             // Open the file.
   Scanner inputFile = new Scanner(file);   // Scanner throws FileNotFoundException
   
   while (inputFile.hasNext()) // Read and display the file's contents.
   {
     System.out.println(inputFile.nextLine());
   }
   
   inputFile.close();       // Close the file.
}

  public static void main(String[] args) {


    FileWriter fileWriter = new FileWriter("names.txt", true);
    PrintWriter printWriter = new PrintWriter(fileWriter);

    Scanner myObj = new Scanner(System.in);                   // Create a Scanner object
    System.out.println("Enter a number (0 to exit)");

    boolean continueLooping = true;
    while (continueLooping) {
      String keyboardInput = myObj.nextLine();                  // Read user input
      int num = Integer.parseInt(keyboardInput);                // convert user input to a number
      System.out.printf("The number you entered is %d: ", num); // Output the number

      if(num == 0) {
        continueLooping = false;
      }
    }
    myObj.close();

    String text = "abcdefghijklmnop";
    for (int index = 0; index < text.length(); index++) {
      char currentChar = text.charAt(index);
      index = index + 1;
    }

  PrintWriter outputFile = new PrintWriter("Output.txt"); // create a file named Output.txt
  outputFile.println("Line 1");                           // write text to the file; note
  outputFile.println("Line 2");                           // that a line feed is added
  outputFile.println("Line 3");
  outputFile.close();                                     // close the file

  DayOfWeek today = DayOfWeek.SUNDAY;
  switch(today) {
    case SATURDAY:
    case SUNDAY:
      System.out.println("Today is a weekend");
      break;
    default:
    System.out.println("Today is not a weekend");
  }
  
  

      // execute statements
    }
}


