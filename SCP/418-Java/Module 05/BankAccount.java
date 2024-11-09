/**
   The BankAccount class stores data about a bank account
   for the BankAccount and SavingsAccount Classes 
   programming challenge.
*/

public abstract class BankAccount
{
   private double balance;                // Account balance
   private int numDeposits;               // Number of deposits
   private int numWithdrawals;            // Number of withdrawals
   private double interestRate;           // Interest rate
   private double monthlyServiceCharges;  // Service charges

   /**
      The constructor initializes the account with
      a balance, an interest rate, and monthly
      service charges.
      @param bal The balance.
      @param intRate The interest rate.
      @param mon The monthly service charges.
   */

   public BankAccount(double bal, double intRate,
                      double mon)
   {
      balance = bal;
      interestRate = intRate;
      monthlyServiceCharges = mon;
      numDeposits = 0;
      numWithdrawals = 0;
   }

   /**
      The deposit method makes a deposit
      into the account.
      @param amount The amount to deposit.
   */

   public void deposit(double amount)
   {
      balance += amount;
      numDeposits++;
   }

   /**
      The withdraw method withdraws an amount
      from the account.
      @param amount The amount to withdraw.
   */

   public void withdraw(double amount)
   {
      balance -= amount;
      numWithdrawals++;
   }

  /**
      The calcInterest method calculates the monthly
      interest and adds it to the account balance.
   */
   
   private void calcInterest()
   {
      // Get the monthly interest rate.
      double monIntRate = interestRate / 12;
      
      // Get the amount of interest for the month.
      double monInterest = balance * monIntRate;
      
      // Add the interest to the balance.
      balance += monInterest;
   }

  /**
      The monthlyProcess method subtracts the
      monthly service charge from the account
      balance and adds the monthly interest.
      The number of deposits and number of
      withdrawals are set to 0.
   */
   
   public void monthlyProcess()
   {
      // Subtract the monthly service charges
      // from the balance.
      balance -= monthlyServiceCharges;
      
      // Calculate and add the interest for
      // the month.
      calcInterest();
      
      // Reset the number of deposits and
      // withdrawals to zero.
      numDeposits = 0;
      numWithdrawals = 0;
   }
   
  /**
      The setMonthlyServiceCharges method sets
      the monthly service charge to a specified
      amount.
      @param m The amount of monthly service charge.
   */
   
   public void setMonthlyServiceCharges(double m)
   {
      monthlyServiceCharges = m;
   }

  /**
      The getBalance method returns the account balance.
      @return The account balance.
   */
   
   public double getBalance()
   {
      return balance;
   }

  /**
      The getNumDeposits method returns the
      number of deposits.
      @return The number of deposits.
   */
   
   public int getNumDeposits()
   {
      return numDeposits;
   }

  /**
      The getNumWithdrawals method returns the
      number of withdrawals.
      @return The number of withdrawals.
   */
   
   public int getNumWithdrawals()
   {
      return numWithdrawals;
   }

  /**
      The getInterestRate method returns the
      interest rate.
      @return The interest rate.
   */
   
   public double getInterestRate()
   {
      return interestRate;
   }

  /**
      The getMonthlyServiceCharges method returns
      the monthly service charges
      @return The motnhly service charges.
   */
   
   public double getMonthlyServiceCharges()
   {
      return monthlyServiceCharges;
   }
}
