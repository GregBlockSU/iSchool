/**
   InvalidTestScore exceptions are thrown by
   TestScore objects when an invalid test score is
   passed into the constructor for the TestScores 
	Class Custom Exception programming challenge.
*/

public class InvalidTestScore extends Exception
{
   /**
      No-arg constructor
   */
   
   public InvalidTestScore()
   {
      super("Invalid test score");
   }
   
   /**
      This constructor reports the element number
      of the array containing the invalid score
      and the value stored in that element.
      @param element The element containing the
                     invalid score.
      @param score The invalid score.
   */
   
   public InvalidTestScore(int element, double score)
   {
      super("Element: " + element + " Invalid Score: " + score);
   }
}
