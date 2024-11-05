/**
   Patient Charges problem
*/

class PatientCharges
{
   public static void main(String[] args)
   {
      // Create an instance of the Patient class.
      Patient patient = new Patient("Jenny", "Elaine", "Santori", "123 Main Street",
                                    "MyTown", "CA", "01234", "Bill Santori", 
                                    "777-555-1212");
                            
      // Create some Procedure instances.
      Procedure procedure1 = new Procedure("Physical Exam", "7/20/2019", "Dr. Irvine", 250.0);
      Procedure procedure2 = new Procedure("X-ray", "7/20/2019", "Dr. Jamison", 500.0);
      Procedure procedure3 = new Procedure("Blood Test", "7/20/2019", "Dr. Smith", 200.0);
      
      // Display the information.
      displayPatient(patient);
      displayProcedure(procedure1);
      displayProcedure(procedure2);
      displayProcedure(procedure3);
   } 
   
   /**
      The displayPatient method displays a Patient object's information.
   */
   
   public static void displayPatient(Patient p)
   {
      System.out.println("Patient name: " + p.getFirstName() + " " +
                         p.getMiddleName() + " " + p.getLastName());
      System.out.println("Address: " + p.getAddress());
      System.out.println("City: " + p.getCity());
      System.out.println("State: " + p.getState());
      System.out.println("ZIP: " + p.getZip());
      System.out.println("Emergency Contact: " + p.getEmergencyName() + " " +
                         p.getEmergencyPhone());
   }
   
   /**
      The displayProcedure method displays a Procedure object's information.
   */

   public static void displayProcedure(Procedure pr)
   {
      System.out.println("Procedure: " + pr.getProcedureName());
      System.out.println("Procedure Date: " + pr.getProcedureDate());
      System.out.println("Practitioner: " + pr.getPractitioner());
      System.out.println("Procedure Charge: " + pr.getCharge() + "\n");
   }
}