import java.util.Scanner;

public class Population
{
   public static void main(String[] args)
   {
      int choice = 0;
      displayAll();
      
      while (choice != 8)
      {
         displayMenu();
         choice = dispatch();
      }
   }
   
   public static void displayMenu()
   {
      System.out.println();
      System.out.println("              MENU");
      System.out.println("1) Sorted by Population in Ascending Order");
      System.out.println("2) Sorted by Population in Descending Order");
      System.out.println("3) Sorted by name");
      System.out.println("4) Total Population of All Cities");
      System.out.println("5) Average Population of All Cities");
      System.out.println("6) Find the Highest Population");
      System.out.println("7) Find the Lowest Population");
      System.out.println("8) Exit");
      System.out.print("Enter your choice: ");
   }
   
   public static int dispatch()
   {
      Scanner keyboard = new Scanner(System.in);
      int choice = keyboard.nextInt();
      
      while (choice < 1 || choice > 8)
      {
         System.out.println("Your selection must be in the range 1-8.");
         System.out.print("Enter your choice: ");
         choice = keyboard.nextInt();
      }
      
      switch(choice)
      {
         case 1:  displayAscending();
                  break;
         case 2:  displayDescending();
                  break;
         case 3:  displayByName();
                  break;
         case 4:  displayTotal();
                  break;
         case 5:  displayAverage();
                  break;
         case 6:  displayHighest();
                  break;
         case 7:  displayLowest();
                  break;
      }
      
      return choice;
   }
   
   public static void displayAll()
   {
      // Create a new instance of CityDBQuery.
		CityDBQuery dbQuery = new CityDBQuery("SELECT * FROM City");
      
      // Get the table data.
      String[][] data = dbQuery.getTableData();
      
      // Display the data.
      displayTable(data);
   }
   
   public static void displayAscending()
   {
      // Create a new instance of CityDBQuery.
		CityDBQuery dbQuery = new CityDBQuery("SELECT * FROM City ORDER BY Population");
      
      // Get the table data.
      String[][] data = dbQuery.getTableData();
      
      // Display the data.
      displayTable(data);
   }
   
   public static void displayDescending()
   {
      // Create a new instance of CityDBQuery.
		CityDBQuery dbQuery = new CityDBQuery("SELECT * FROM City ORDER BY Population DESC");
      
      // Get the table data.
      String[][] data = dbQuery.getTableData();
      
      // Display the data.
      displayTable(data);
   }
   
   public static void displayByName()
   {
      // Create a new instance of CityDBQuery.
		CityDBQuery dbQuery = new CityDBQuery("SELECT * FROM City ORDER BY CityName");
      
      // Get the table data.
      String[][] data = dbQuery.getTableData();
      
      // Display the data.
      displayTable(data);
   }
   
   public static void displayTotal()
   {
      // Create a new instance of CityDBQuery.
		CityDBQuery dbQuery = new CityDBQuery("SELECT SUM(Population) AS Total FROM City");
      
      // Get the table data.
      String[][] data = dbQuery.getTableData();
      
      // Display the data.
      System.out.println("Total Population: " + String.format("%,.2f", Double.parseDouble(data[0][0])));
   }
   
   public static void displayAverage()
   {
      // Create a new instance of CityDBQuery.
		CityDBQuery dbQuery = new CityDBQuery("SELECT AVG(Population) AS Total FROM City");
      
      // Get the table data.
      String[][] data = dbQuery.getTableData();
      
      // Display the data.
      System.out.println("Average Population: " + String.format("%,.2f", Double.parseDouble(data[0][0])));
   }
   
   public static void displayHighest()
   {
      // Create a new instance of CityDBQuery.
		CityDBQuery dbQuery = new CityDBQuery("SELECT MAX(Population) AS Highest FROM City");
      
      // Get the table data.
      String[][] data = dbQuery.getTableData();
      
      // Display the data.
      System.out.println("Highest Population: " + String.format("%,.2f", Double.parseDouble(data[0][0])));
   }
   
   public static void displayLowest()
   {
      // Create a new instance of CityDBQuery.
		CityDBQuery dbQuery = new CityDBQuery("SELECT MIN(Population) AS Lowest FROM City");
      
      // Get the table data.
      String[][] data = dbQuery.getTableData();
      
      // Display the data.
      System.out.println("Lowest Population: " + String.format("%,.2f", Double.parseDouble(data[0][0])));
   }
   
   public static void displayTable(String[][] data)
   {
      System.out.println("Cities and their population");
      System.out.println("----------------------------------------");
      
      // Display the data.
      for (int row = 0; row < data.length; row++)
      {
         // Display the city name.
         System.out.print(data[row][0] + "\t");
         
         // Format and display the population.
         System.out.println(String.format("%,.2f", Double.parseDouble(data[row][1])));
      }
      System.out.println("----------------------------------------");
   }
}