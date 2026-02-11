import java.sql.*;

/**
   This class executes queries on the CityDB database
   and provides the results in arrays for the Population
	Database programming challenge.
*/

public class CityDBQuery
{
   // Database URL Constant
   public final String DB_URL = "jdbc:derby:CityDB";

   private Connection conn;      // Database connection
   private String[][] tableData; // Table data
   private String[] colNames;    // Column names

   /**
       Constructor
   */

   public CityDBQuery(String query)
   {
      // Get a connection to the database.
      getDatabaseConnection();

      try
      {
         // Create a Statement object for the query.
         Statement stmt =
            conn.createStatement(
                    ResultSet.TYPE_SCROLL_INSENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

         // Execute the query.
         ResultSet resultSet =
                   stmt.executeQuery(query);

         // Get the number of rows.
         resultSet.last();                 // Move to last row
         int numRows = resultSet.getRow(); // Get row number
         resultSet.first();                // Move to first row

         // Get a metadata object for the result set.
         ResultSetMetaData meta = resultSet.getMetaData();

         // Create an array of Strings for the column names.
         colNames = new String[meta.getColumnCount()];

         // Store the column names in the colNames array.
         for (int i = 0; i < meta.getColumnCount(); i++)
         {
            // Get a column name.
            colNames[i] = meta.getColumnLabel(i+1);
         }

         // Create a 2D String array for the table data.
         tableData =
            new String[numRows][meta.getColumnCount()];

         // Store the columns in the tableData array.
         for (int row = 0; row < numRows; row++)
         {
            for (int col = 0; col < meta.getColumnCount(); col++)
            {
               tableData[row][col] = resultSet.getString(col + 1);
            }

            // Go to the next row in the ResultSet.
            resultSet.next();
         }

         // Close the statement and connection objects.
         stmt.close();
         conn.close();
      }
      catch (SQLException ex)
      {
         ex.printStackTrace();
      }
   }

   /**
       The getDatabaseConnection method loads the JDBC
       and gets a connection to the database.
   */

   private void getDatabaseConnection()
   {
      try
      {
         // Create a connection to the database.
         conn = DriverManager.getConnection(DB_URL);
      }
      catch (Exception ex)
      {
         ex.printStackTrace();
         System.exit(0);
      }
   }

   /**
       The getColumnNames method returns the column names.
   */

   public String[] getColumnNames()
   {
      return colNames;
   }

   /**
       The getTableData method returns the table data.
   */

   public String[][] getTableData()
   {
      return tableData;
   }
 }