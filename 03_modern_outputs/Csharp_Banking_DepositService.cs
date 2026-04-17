namespace Enterprise.Banking.Deposits;

public record DepositCalculationRequest(decimal Principal, decimal Rate, int Years, int Frequency);

public class DepositService
{
    // Мігрована логіка з COBOL DEPOSIT-CALC.CBL
    public decimal CalculateFutureValue(DepositCalculationRequest request)
    {
        if (request.Principal <= 0) return 0;
        
        // Математично точна реалізація формули складних відсотків
        double baseRate = 1 + (double)(request.Rate / request.Frequency);
        double exponent = request.Frequency * request.Years;
        decimal futureValue = request.Principal * (decimal)Math.Pow(baseRate, exponent);
        
        return Math.Round(futureValue, 2);
    }
}
