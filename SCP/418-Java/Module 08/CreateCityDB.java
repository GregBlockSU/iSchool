/** code for the CityDB */

import java.sql.*;
import java.util.HashMap;
/**
This program creates the CityDB database. *
*/

public class CreateCityDB
{
    final static String DB_URL = "jdbc:derby:CityDB;create=true";
    final static String CREATE_TABLE_SQL = """
    CREATE TABLE City
    (
        CityName CHAR(25) NOT NULL PRIMARY KEY,
        Population DOUBLE
    )""";
    public static void main(String[] args) throws Exception, SQLException
    {
        HashMap<String, Integer> cities = new HashMap();
        cities.put("Beijing", 12500000);
        cities.put("Buenos Aires", 13170000);
        cities.put("Cairo", 14450000);
        cities.put("Calcutta", 15100000);
        cities.put("Delhi", 18680000);
        cities.put("Jakarta", 18900000);
        cities.put("Karachi", 11800000);
        cities.put("Lagos", 13488000);
        cities.put("London", 12875000);
        cities.put("Los Angeles", 15250000);
        cities.put("Manila", 16300000);
        cities.put("Mexico City", 20450000);
        cities.put("Moscow", 15000000);
        cities.put("Mumbai", 19200000);
        cities.put("New York City", 19750000);
        cities.put("Osaka", 17350000);
        cities.put("Sao Paulo", 18850000);
        cities.put("Seoul", 20550000);
        cities.put("Shanghai", 16650000);
        cities.put("Tokyo", 32450000);

        try
        {
            // Create a Statement object.
            try ( 
                    // Create a connection to the database.
                    // Create a Statement object.
                    Connection conn = DriverManager.getConnection(DB_URL);
                    Statement stmt = conn.createStatement()) 
                    {                
                        createTable(stmt);

                        // Using forEach with a lambda expression
                        cities.forEach((key, value) -> {
                            try {
                                insertCity(stmt, key, value);
                            } catch (SQLException ex) {
                                System.out.println("ERROR: " + ex.getMessage());
                            }
                        });
                    }
            System.out.println("Done");
        }
        catch(SQLException ex)
        {
            System.out.println("ERROR: " + ex.getMessage());
        }
        catch(Exception ex)
        {
            System.out.println("ERROR: " + ex.getMessage());
        }
    }

    public static void createTable(Statement stmt) throws Exception
    {
        System.out.println("Creating the City table...");
        System.out.println(CREATE_TABLE_SQL);
        stmt.execute(CREATE_TABLE_SQL);
    }

    public static void insertCity(Statement stmt, String cityName, int population) throws SQLException
    {
        String sql = String.format("INSERT INTO City VALUES ('%s', %d)", cityName, population);
        System.out.println(sql);
        stmt.executeUpdate(sql);
    }
}