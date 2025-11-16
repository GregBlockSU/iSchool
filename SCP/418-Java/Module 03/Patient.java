
public class Patient
{
   private String firstName;
   private String middleName;
   private String lastName;
   private String address;
   private String city;
   private String state;
   private String zip;
   private String emergencyName;
   private String emergencyPhone;
   
   // Constructor
   public Patient(String first, String middle, String last, String addr,
                  String cty, String st, String z, String emergName, String emergPh)
   {
      firstName = first;
      middleName = middle;
      lastName = last;
      address = addr;
      city = cty;
      state = st;
      zip = z;
      emergencyName = emergName;
      emergencyPhone = emergPh;
   }
   
   // Mutators
   public void setFirstName(String fn)
   {
      if (fn != "")
      {
         firstName = fn;
      }
   }
   
   public void setMiddleName(String mn)
   {
      middleName = mn;
   }

   public void setLastName(String ln)
   {
      lastName = ln;
   }
   
   public void setAddress(String addr)
   {
      address = addr;
   }

   public void setCity(String cty)
   {
      city = cty;
   }
   
   public void setState(String st)
   {
      state = st;
   }
   
   public void setZip(String z)
   {
      zip = z;
   }
   
   public void setEmergencyName(String en)
   {
      emergencyName = en;
   }
   
   public void setEmergencyPhone(String eph)
   {
      emergencyPhone = eph;
   }
   
   // Accessors
   public String getFirstName()
   {
      return firstName;
   }
   
   public String getMiddleName()
   {
      return middleName;
   }

   public String getLastName()
   {
      return lastName;
   }

   public String getFullName()
   {
      return firstName + " " + middleName + " " + lastName;
   }
   
   public String getAddress()
   {
      return address;
   }

   public String getCity()
   {
      return city;
   }
   
   public String getState()
   {
      return state;
   }
   
   public String getZip()
   {
      return zip;
   }
   
   public String getEmergencyName()
   {
      return emergencyName;
   }
   
   public String getEmergencyPhone()
   {
      return emergencyPhone;
   }
}