/**
   This program demonstrates a solution to the
   TestScores Class Custom Exception programming 
	challenge.
*/

public class TestScoresDemo
{
   public static void main(String[] args)
   {
      // An array with test scores.
      // Notice that element 3 contains an invalid score.
      double[] badScores = {97.5, 66.7, 88.0, 101.0, 99.0 };

      // Another array with test scores.
      // All of these scores are good.
      double[] goodScores = {97.5, 66.7, 88.0, 100.0, 99.0 };
      
      // Create a TestScores object initialized with badScores.
      try
      {
         TestScores tBad = new TestScores(badScores);
         // The following statement should not execute.
         System.out.println("The average of the bad scores is " +
                            tBad.getAverage());
      }
      catch (InvalidTestScore e)
      {
         System.out.println("Invalid score found.\n" + e.getMessage());
      }
      catch(Exception e)
      {
         System.out.println("Oops.Something unexpected happened.\n" + e.getMessage());
      }
   
      // Create a TestScores object initialized with goodScores.
      try
      {
         TestScores tGood = new TestScores(goodScores);
         System.out.println("The average of the good scores is " +
                            tGood.getAverage());
      }
      catch (InvalidTestScore e)
      {
         System.out.println("Invalid score found.\n" + e.getMessage());
      }
   }
}
