import java.util.Scanner;

/**
ScP 418

Module 1 Assignment
A vineyard owner is planting several new rows of grapevines and needs to know how many grapevines 
to plant in each row. She has determined that after measuring the length of a future row, 
she can use the following formula to calculate the number of vines that will fit in the row, 
along with the trellis end-post assemblies that will need to be constructed at each end of the row:

V=(R-2E)/S

The terms in the formula are:
	V is the number of grapevines that will fit in the row.
	R is the length of the row, in feet.
	E is the amount of space used by an end-post assembly.
	S is the space between vines, in feet.

Write a program that makes the calculation for the vineyard owner. The program should ask the 
user to input the following:

	The length of the row, in feet (R)
	The amount of space used by an end-post assembly, in feet (E)
	The amount of space between the vines, in feet (S)

Once the input data has been entered, the program should calculate and display the number of 
grapevines that will fit in the row.

*/
 
public class Grapevines
{
   public static void main(String[] args)
   {
      // Variables
      double vines,              // Number of vines
             rowLength,          // Length of a row
             endpost,            // Endpost assembly space
             vineSpacing;        // Space between vines
      
      // Create a Scanner object for keyboard input.
      Scanner keyboard = new Scanner(System.in);
      
      // Get the necessary input.
      System.out.print("What is the length of a row, in feet? ");
      rowLength = keyboard.nextDouble();
      System.out.print("How many feet does an endpost assembly require? ");
      endpost = keyboard.nextDouble();
      System.out.print("What is the space between vines, in feet? ");
      vineSpacing = keyboard.nextDouble();
      
      // Calculate the number of vines.
      vines = (rowLength - 2 * endpost) / vineSpacing;
      
      // Display the result.
      System.out.println("You can fit " + vines + " vines in a row.");
   }
}
