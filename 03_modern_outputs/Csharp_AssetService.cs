using System;

namespace Enterprise.Accounting.Services
{
    public interface IAssetDepreciationService
    {
        decimal CalculateDepreciation(decimal cost, decimal currentValue);
    }

    public class AssetDepreciationService : IAssetDepreciationService
    {
        private const decimal DepreciationRate = 0.15m;
        private const decimal SalvageValue = 100.00m;

        // Clean business logic extracted via QCA Sequencer
        public decimal CalculateDepreciation(decimal cost, decimal currentValue)
        {
            if (cost <= 0) return 0;

            decimal calculatedDepreciation = cost * DepreciationRate;
            decimal newValue = currentValue - calculatedDepreciation;

            // Business rule: floor at salvage value
            if (newValue < SalvageValue)
            {
                calculatedDepreciation = currentValue - SalvageValue;
            }

            return calculatedDepreciation > 0 ? calculatedDepreciation : 0;
        }
    }
}