/**
   The ParkingTicket class stores data about a parking ticket
   for the Parking Ticket Simulator programming challenge.
*/


public class ParkingTicket
{
   private ParkedCar car;           // The parked car
   private PoliceOfficer officer;   // The police officer
   private double fine;             // The parking fine
   private int minutes;             // Minutes illegally parked

   // Constant for the base fine.
   public final double BASE_FINE = 25.0;

   // Contant for the additional hourly fine.
   public final double HOURLY_FINE = 10.0;

   /**
      Constructor
      @param aCar A ParkedCar object.
      @param anOfficer A PoliceOfficer object.
      @param min Minutes illegally parked.
   */

   public ParkingTicket(ParkedCar aCar,
                        PoliceOfficer anOfficer,
                        int min)
   {
      // Make a copy of the object referenced by aCar.
      car = new ParkedCar(aCar);

      // Make a copy of the object referenced by anOfficer.
      officer = new PoliceOfficer(anOfficer);

      // Assign the minutes illegally parked.
      minutes = min;

      // Calculate the fine.
      calculateFine();
   }

   /**
      Copy constructor
      @param ticket2 A ParkingTicket object to copy.
   */

   public ParkingTicket(ParkingTicket ticket2)
   {
      // Make a copy of the object referenced by aCar.
      car = new ParkedCar(ticket2.car);

      // Make a copy of the object referenced by anOfficer.
      officer = new PoliceOfficer(ticket2.officer);

      // Assign the fine.
      fine = ticket2.fine;
   }

   /**
      calculateFine method
      This method calculates the amount of the parking fine.
   */

   private void calculateFine()
   {
      // Get the time parked in hours.
      double hours = minutes / 60.0;

      // Get the hours as an int.
      int hoursAsInt = (int)hours;

      // If there was a portion of an hour, round up.
      if ((hours - hoursAsInt) > 0)
         hoursAsInt++;

      // Assign the base fine.
      fine = BASE_FINE;

      // Add the additional hourly fines.
      fine += (hoursAsInt * HOURLY_FINE);
   }

   /**
      setCar method
      @param c A ParkedCar object.
   */

   public void setCar(ParkedCar c)
   {
      // Make a copy of the object referenced by c.
      car = new ParkedCar(c);
   }

   /**
      setOfficer method
      @param o A PoliceOfficer object.
   */

   public void setOfficer(PoliceOfficer o)
   {
      // Make a copy of the object referenced by o.
      officer = new PoliceOfficer(o);
   }

   /**
      getCar method
      @return A copy of this object's car field.
   */

   public ParkedCar getCar()
   {
      // Return a copy of the car object.
      return new ParkedCar(car);
   }

   /**
      getFine method
      @return The amount of the fine.
   */

   public double getFine()
   {
      return fine;
   }

   /**
      getOfficer method
      @return A copy of this object's officer field.
   */

   public PoliceOfficer getOfficer()
   {
      // Return a copy of the officer object.
      return new PoliceOfficer(officer);
   }

   /**
      toString method
      @return A string stating data about the car, the
              police officer, and the parking violation.
   */

   public String toString()
   {
      // Build a state string.
      String str = String.format("Car Data:\n" +
                                 "%s\n" +
                                 "Officer Data:\n" +
                                 "%s\n" +
                                 "Minutes Illegally Parked: %d\n" +
                                 "Fine: $%,.2f\n",
                                 car, officer, minutes, fine);

      // Return the string.
      return str;
   }
}
