using System;
using System.Linq;
using System.Collections.Generic;

namespace Enterprise.SupplyChain.Inventory
{
    /// <summary>
    /// Modernized via QCA Framework.
    /// Pure Domain Service: Calculates FIFO Cost of Goods Sold without DB coupling.
    /// </summary>
    public class FifoValuationService
    {
        public void CalculateCogs(SaleLine sale, List<GoodsReceipt> receipts, InventoryItem masterItem)
        {
            decimal qtyToCost = sale.QtySold;
            decimal totalCogs = 0m;

            // Strictly ordered by date for FIFO compliance
            var availableReceipts = receipts
                .Where(r => r.ItemId == sale.ItemId && r.QtyAvailable > 0)
                .OrderBy(r => r.ReceiptDate);

            foreach (var receipt in availableReceipts)
            {
                if (qtyToCost <= 0) break;

                decimal consumedQty = Math.Min(receipt.QtyAvailable, qtyToCost);
                
                totalCogs += consumedQty * receipt.UnitPrice;
                receipt.QtyAvailable -= consumedQty;
                qtyToCost -= consumedQty;
            }

            // Architecture enhancement: Handling the missing legacy constraint
            if (qtyToCost > 0)
            {
                throw new InvalidOperationException($"Negative stock anomaly for Item {sale.ItemId}");
            }

            sale.Cogs = totalCogs;
            sale.IsProcessed = true;
            masterItem.TotalQty -= sale.QtySold;
        }
    }
    
    // Domain Models (Data Transfer Objects)
    public class SaleLine 
    { 
        public string ItemId { get; set; }
        public decimal QtySold { get; set; }
        public decimal Cogs { get; set; }
        public bool IsProcessed { get; set; }
    }
    
    public class GoodsReceipt 
    { 
        public string ItemId { get; set; }
        public DateTime ReceiptDate { get; set; }
        public decimal QtyAvailable { get; set; }
        public decimal UnitPrice { get; set; }
    }
    
    public class InventoryItem 
    { 
        public string ItemId { get; set; }
        public decimal TotalQty { get; set; }
    }
}