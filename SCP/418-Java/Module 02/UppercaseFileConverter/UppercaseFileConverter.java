import java.util.Scanner;
import java.io.*;

/**
   This program demonstrates a solution to the
   Uppercase File Converter programming challenge.
*/

public class UppercaseFileConverter
{
   public static void main(String[] args) throws IOException
   {
      String inFilename;   // The name of the input file
      String outFilename;  // The name of the output file
      String input;        // To hold file input
      String output;       // To hold file output

      // Create a Scanner object for keyboard input.
      Scanner keyboard = new Scanner(System.in);
             
      // Get the input file name.
      System.out.print("Enter the input file name: ");
      inFilename = keyboard.nextLine();

      // Get the output file name.
      System.out.print("Enter the output file name: ");
      outFilename = keyboard.nextLine();
      
      // Open the input file.
      File file = new File(inFilename);
      Scanner inFile = new Scanner(file);
            
      // Open the output file.
      PrintWriter outFile = new PrintWriter(outFilename);

      // Process the files.
      while (inFile.hasNext())
      {
         input = inFile.nextLine();
         output = input.toUpperCase();
         outFile.println(output);
      }
      
      // Close the files.
      inFile.close();
      outFile.close();
   }
}
