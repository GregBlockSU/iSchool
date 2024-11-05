import java.util.Scanner;
import java.io.*;

/*
This program illustrates how to close a file using finally and
how to close a file using try-with-resources
*/

public class FileManager
{
   public static void main(String[] args) throws IOException
   {
      // read the file name as a command line parameter
      String fileName = args[0];
      System.out.println("Test file " + fileName);
      CloseFileWithFinally(fileName);
      CloseFileWithTry(fileName);
   }

   // closes the scanner using a try/catch/finall
   private static void CloseFileWithFinally(String fileName)
   {
      Scanner scanner = null;
      File file = new File(fileName);
      try
      {
        scanner = new Scanner(file);
        System.out.println("In try");
        // Process the files.
        while (scanner.hasNext())
        {
           String input = scanner.nextLine();
           System.out.println(input);
        }
     }
     catch(FileNotFoundException ex)
     {
        System.out.println("In catch");
     }
     finally
     {
        System.out.println("In catch");
        if (scanner != null)
        {
           scanner.close();
        }      
     }
   }

   // closes the scanner using a try-with-resources
   private static void CloseFileWithTry(String fileName)
   {
      File file = new File(fileName);
      try(Scanner scanner = new Scanner(file))
      {
        System.out.println("In try");
        // Process the files.
        while (scanner.hasNext())
        {
           String input = scanner.nextLine();
           System.out.println(input);
        }
     }
     catch(FileNotFoundException ex)
     {
        System.out.println("In catch");
     }
     finally
     {
        System.out.println("In catch");    
     }
   }

}
