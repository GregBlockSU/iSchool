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
      Procedure procedure1 = new Procedure(patient, "Physical Exam", "7/20/2019", "Dr. Irvine", 250.0);
      Procedure procedure2 = new Procedure(patient, "X-ray", "7/20/2019", "Dr. Jamison", 500.0);
      Procedure procedure3 = new Procedure(patient, "Blood Test", "7/20/2019", "Dr. Smith", 200.0);
      
      // Display the information.
      display(patient);
      display(procedure1);
      display(procedure2);
      display(procedure3);
   } 
   
   /**
      The displayPatient method displays a Patient object's information.
   */
   
   public void display(Patient patient)
   {
      System.out.println("Patient name: " + patient.getFirstName() + " " +
         patient.getMiddleName() + " " + patient.getLastName());
      System.out.println("Address: " + patient.getAddress());
      System.out.println("City: " + patient.getCity());
      System.out.println("State: " + patient.getState());
      System.out.println("ZIP: " + patient.getZip());
      System.out.println("Emergency Contact: " + patient.getEmergencyName() + " " +
         patient.getEmergencyPhone());
   }
   
   /**
      The displayProcedure method displays a Procedure object's information.
   */

   public static void display(Procedure pr)
   {
      display(pr.getPatient());
      System.out.println("Procedure: " + pr.getProcedureName());
      System.out.println("Procedure Date: " + pr.getProcedureDate());
      System.out.println("Practitioner: " + pr.getPractitioner());
      System.out.println("Procedure Charge: " + pr.getCharge() + "\n");
   }
}