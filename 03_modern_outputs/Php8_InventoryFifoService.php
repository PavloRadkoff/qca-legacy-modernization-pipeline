<?php

declare(strict_types=1);

namespace Enterprise\SupplyChain\Inventory;

use RuntimeException;
use DateTimeImmutable;

// Domain Models (DTOs)
class SaleLine {
    public float $cogs = 0.0;
    public bool $isProcessed = false;
    public function __construct(public string $itemId, public float $qtySold) {}
}

class GoodsReceipt {
    public function __construct(
        public string $itemId, 
        public DateTimeImmutable $receiptDate, 
        public float $qtyAvailable, 
        public float $unitPrice
    ) {}
}

class InventoryItem {
    public function __construct(public string $itemId, public float $totalQty) {}
}

class FifoValuationService {
    /**
     * Modernized via QCA Framework.
     * Decoupled from Legacy DBF files, ready for web-integration.
     * * @param GoodsReceipt[] $receipts
     */
    public function calculateCogs(SaleLine $sale, array $receipts, InventoryItem $masterItem): void {
        $qtyToCost = $sale->qtySold;
        $totalCogs = 0.0;

        // Extract available receipts for this item
        $available = array_filter(
            $receipts, 
            fn(GoodsReceipt $r) => $r->itemId === $sale->itemId && $r->qtyAvailable > 0
        );

        // Sort by date ASC for strict FIFO compliance
        usort($available, fn($a, $b) => $a->receiptDate <=> $b->receiptDate);

        foreach ($available as $receipt) {
            if ($qtyToCost <= 0) break;

            $consumedQty = min($receipt->qtyAvailable, $qtyToCost);
            $totalCogs += $consumedQty * $receipt->unitPrice;
            
            $receipt->qtyAvailable -= $consumedQty;
            $qtyToCost -= $consumedQty;
        }

        // QCA Risk Flag: Stop processing if logic dictates negative stock
        if ($qtyToCost > 0) {
            throw new RuntimeException("Negative stock anomaly for Item {$sale->itemId}. Integration aborted.");
        }

        $sale->cogs = $totalCogs;
        $sale->isProcessed = true;
        $masterItem->totalQty -= $sale->qtySold;
    }
}