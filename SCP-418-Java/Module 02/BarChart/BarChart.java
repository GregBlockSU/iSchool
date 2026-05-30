import java.util.Scanner;  // Needed for keyboard input

/*
Write a program that asks the user to enter today’s sales for five stores. 
The program should display a bar chart comparing each store’s sales. 
Create each bar in the bar chart by displaying a row of asterisks. 
Each asterisk should represent $100 of sales. Here is an example of the 
program’s output:

Enter today's sales for store 1: 1000 [Enter]
Enter today's sales for store 2: 1200 [Enter]
Enter today's sales for store 3: 1800 [Enter]
Enter today's sales for store 4: 800 [Enter]
Enter today's sales for store 5: 1900 [Enter]

SALES BAR CHART
Store 1: **********
Store 2: ************
Store 3: ******************
Store 4: ********
Store 5: *******************

*/

public class BarChart
{
   public static void main(String[] args)
   {
      String bar;    // To hold a line in the bar chart
      int numStars;  // The number of stars to display
      double sales1; // To hold a store 1's sales
      double sales2; // To hold a store 2's sales
      double sales3; // To hold a store 3's sales
      double sales4; // To hold a store 4's sales
      double sales5; // To hold a store 5's sales
                  
      // Create a Scanner object for keyboard input.
      try(Scanner keyboard = new Scanner(System.in))
      {
         for(int x = 0; x < 5;x++)
          {
             // Get the sales for store 1.
             System.out.print("Enter today's sales for store " + (x+1) + ": ");
             sales1 = keyboard.nextDouble();

             displayBar(sales1);
         //    bar = "";
         //    numStars = (int) (sales1 / 100);
         //    for (int i = 0; i < numStars; i++)
         //       bar = bar + "*";
         //    System.out.println(bar);         
         
      }
         // Get the sales for store 1.
         System.out.print("Enter today's sales for store 1: ");
         sales1 = keyboard.nextDouble();

         // Get the sales for store 2.
         System.out.print("Enter today's sales for store 2: ");
         sales2 = keyboard.nextDouble();

         // Get the sales for store 3.
         System.out.print("Enter today's sales for store 3: ");
         sales3 = keyboard.nextDouble();

         // Get the sales for store 4.
         System.out.print("Enter today's sales for store 4: ");
         sales4 = keyboard.nextDouble();

         // Get the sales for store 5.
         System.out.print("Enter today's sales for store 5: ");
         sales5 = keyboard.nextDouble();
      }
      // Display the bar chart heading.
      System.out.println("\nSALES BAR CHART");
      
      // Display the chart for store 1.
      displayBar(sales1);
      displayBar(sales2);
      displayBar(sales3);
      displayBar(sales4);
      displayBar(sales5);
      // // Display the chart for store 2.
      // bar = "";
      // numStars = (int) (sales2 / 100);
      // for (int i = 0; i < numStars; i++)
      //    bar = bar + "*";
      // System.out.println(bar);

      // // Display the chart for store 3.
      // bar = "";
      // numStars = (int) (sales3 / 100);
      // for (int i = 0; i < numStars; i++)
      //    bar = bar + "*";
      // System.out.println(bar);
      
      // // Display the chart for store 4.
      // bar = "";
      // numStars = (int) (sales4 / 100);
      // for (int i = 0; i < numStars; i++)
      //    bar = bar + "*";
      // System.out.println(bar);

      // // Display the chart for store 5.
      // bar = "";
      // numStars = (int) (sales5 / 100);
      // for (int i = 0; i < numStars; i++)
      //    bar = bar + "*";
      // System.out.println(bar);
   }

   public static void displayBar(double sales)
   {
      String bar = "";
      int numStars = (int) (sales / 100);
      for (int i = 0; i < numStars; i++)
      {
         bar = bar + "*";
      }
      System.out.println(bar);
   }
}
