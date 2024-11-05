class Procedure
{
   String procedureName;
   String procedureDate;
   String practitioner;
   double charge;
   
   // Constructor
   public Procedure(String procName, String procDate, String pract, double ch)
   {
      procedureName = procName;
      procedureDate = procDate;
      practitioner = pract;
      charge = ch;
   }
   
   // Mutators
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
}