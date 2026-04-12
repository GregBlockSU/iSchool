public class Procedure
{
   private Patient patient;
   private String procedureName;
   private String procedureDate;
   private String practitioner;
   private double charge;
   
   // Constructor
   public Procedure(Patient pat,String procName, String procDate, String pract, double ch)
   {
      patient = pat;
      procedureName = procName;
      procedureDate = procDate;
      practitioner = pract;
      charge = ch;
   }
   
   // Mutators
   public void setPatient(Patient pat)
   {
      patient = pat;
   }
   public void setProcedureName(String procName)
   {
      procedureName = procName;
   }
   
   public void setProcedureDate(String procDate)
   {
      procedureDate = procDate;
   }
   
   public void setPractitioner(String pract)
   {
      practitioner = pract;
   }
   
   public void setCharge(double ch)
   {
      charge = ch;
   }

   // Accessors
   public String getProcedureName()
   {
      return procedureName;
   }
   
   public String getProcedureDate()
   {
      return procedureDate;
   }
   
   public String getPractitioner()
   {
      return practitioner;
   }
   
   public double getCharge()
   {
      return charge;
   }

   public Patient getPatient()
   {
      return patient;
   }
}