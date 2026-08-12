using System;

namespace Enterprise.CoreBanking.Services
{
    /// <summary>
    /// Modernized via QCA Framework.
    /// Pure Domain Service: Calculates Account Interest decoupled from Mainframe batch processing.
    /// </summary>
    public class InterestCalculationService
    {
        public void CalculateAndApplyInterest(Account account)
        {
            if (account.Balance <= 0)
            {
                account.LastCalculatedInterest = 0m;
                return;
            }

            decimal interestRate = account.AccountType switch
            {
                AccountType.Savings => 0.0350m,
                AccountType.Checking => 0.0125m,
                _ => 0.0000m
            };

            // Applying Banker's Rounding (MidpointRounding.ToEven) to match COBOL ROUNDED precision
            decimal calculatedInterest = Math.Round(account.Balance * interestRate, 2, MidpointRounding.ToEven);
            
            account.LastCalculatedInterest = calculatedInterest;
            account.Balance += calculatedInterest;
        }
    }

    // Domain Models (Data Transfer Objects)
    public enum AccountType
    {
        Savings, // 'S'
        Checking, // 'C'
        Other
    }

    public class Account
    {
        public string AccountNumber { get; set; } = string.Empty;
        public decimal Balance { get; set; }
        public AccountType AccountType { get; set; }
        public decimal LastCalculatedInterest { get; set; }
    }
}