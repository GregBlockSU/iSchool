/**
   The BankAccount class stores data about a bank 
   account with savings capabilites for the 
   BankAccount and SavingsAccount Classes 
   programming challenge.
*/

public class SavingsAccount extends BankAccount
{
   private boolean status; // Active or inactive
   
   /**
      The constructor initializes the account with
      a balance, an interest rate, and monthly
      service charges. If the balance is less than
      $25 the account is set as inactive. Otherwise
      it is set as active.
      @param bal The balance.
      @param intRate The interest rate.
      @param mon The monthly service charges.
   */

   public SavingsAccount(double bal, double intRate,
                         double mon)
   {
      super(bal, intRate, mon);
      if (bal < 25.0)
         status = false;   // Inactive
      else
         status = true;    // Active
   }

   public void hello(){}
   /**
      The withdraw method withdraws an amount
      from the account if the account is active.
      If the account is inactive, no withdrawal
      is made. (Overrides the super class method.)
      @param amount The amount to withdraw.
   */
   
   @Override
   public void withdraw(double amount)
   {
      if (status)
      {
         super.withdraw(amount);
         if (getBalance() < 25)
            status = false;
      }
   }  
   
   /**
      The deposit method makes a deposit
      into the account. If the account is
      inactive and the deposit raises the
      balance to $25 or more, the account
      is made active. (Overrides the super
      class method.)
      @param amount The amount to deposit.
   */
   
   @Override
   public void deposit(double amount)
   {
      super.deposit(amount);
      if (!status)
      {
         if (getBalance() >= 25)
            status = true;
      }
   }

  /**
      The monthlyProcess method calls the super
      class's monthlyProcess method. If the number
      of withdrawals is greater tha n 4, the
      monthly service charges are increased.
   */
  @Override  
   public void monthlyProcess()
   {
      double msc;    // Monthly service charge
      
      if (getNumWithdrawals() > 4)
      {
         // Get the monthly service charges.
         msc = getMonthlyServiceCharges();
         // Increase the monthly service charges.
         setMonthlyServiceCharges(msc + (getNumWithdrawals() - 4));
         // Do the monthly processing.
         super.monthlyProcess();
         // Set the monthly charges back.
         setMonthlyServiceCharges(msc);
      }
      else
         super.monthlyProcess();       
   }
}
