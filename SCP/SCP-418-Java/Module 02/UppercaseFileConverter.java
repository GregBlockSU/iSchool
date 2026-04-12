import java.util.Scanner;
import java.io.*;

/*
Write a program that asks the user for the names of two files. The first file 
should be opened for reading and the second file should be opened for writing. 
The program should read the contents of the first file, change all characters to 
uppercase, and store the results in the second file. The second file will be a 
copy of the first file, except that all the characters will be uppercase. Use 
Notepad or another text editor to create a simple file that can be used to test the 
program. If the second file already exists, generate a message instead of overwriting the file.
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
