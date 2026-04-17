from dataclasses import dataclass
from typing import List
from datetime import date

# Domain Models (DTOs)
@dataclass
class SaleLine:
    item_id: str
    qty_sold: float
    cogs: float = 0.0
    is_processed: bool = False

@dataclass
class GoodsReceipt:
    item_id: str
    receipt_date: date
    qty_available: float
    unit_price: float

@dataclass
class InventoryItem:
    item_id: str
    total_qty: float

class FifoValuationService:
    """
    Modernized via QCA Framework.
    Pure Domain Service translated from FoxPro IR.
    """
    def calculate_cogs(self, sale: SaleLine, receipts: List[GoodsReceipt], master_item: InventoryItem) -> None:
        qty_to_cost = sale.qty_sold
        total_cogs = 0.0

        # Strictly ordered by date for FIFO compliance (Filtering + Sorting)
        available_receipts = sorted(
            [r for r in receipts if r.item_id == sale.item_id and r.qty_available > 0],
            key=lambda r: r.receipt_date
        )

        for receipt in available_receipts:
            if qty_to_cost <= 0:
                break

            consumed_qty = min(receipt.qty_available, qty_to_cost)
            
            total_cogs += consumed_qty * receipt.unit_price
            receipt.qty_available -= consumed_qty
            qty_to_cost -= consumed_qty

        # Risk mitigation identified during IR extraction
        if qty_to_cost > 0:
            raise ValueError(f"Negative stock anomaly for Item {sale.item_id}. Missing receipt data.")

        sale.cogs = total_cogs
        sale.is_processed = True
        master_item.total_qty -= sale.qty_sold