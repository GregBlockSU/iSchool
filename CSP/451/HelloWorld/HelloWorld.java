
// this is the HelloWorld sample program

import java.util.Scanner;  // Import the Scanner class

class HelloWorld {
  public static void main(String[] args) {
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

      // execute statements
    }
}


