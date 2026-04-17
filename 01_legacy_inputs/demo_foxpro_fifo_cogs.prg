* MODULE: WAREHOUSE FIFO COST CALCULATION (2001)
* Розрахунок собівартості проданих товарів (COGS) методом FIFO

SET TALK OFF
SET EXCLUSIVE OFF

* Жорстка прив'язка до фізичних файлів
SELECT 1
USE inventory_items INDEX item_id SHARED
SELECT 2
USE goods_receipts INDEX rcpt_item_date SHARED
SELECT 3
USE sales_lines INDEX sale_date SHARED

SELECT sales_lines
* Початок глобального циклу по непроведених продажах
SCAN FOR processed = .F.
    m.qty_to_cost = qty_sold
    m.total_cost = 0

    SELECT goods_receipts
    SET ORDER TO rcpt_item_date
    SEEK sales_lines.item_id

    * Вкладений цикл пошуку залишків з найстаріших партій (FIFO)
    SCAN REST WHILE item_id = sales_lines.item_id AND m.qty_to_cost > 0
        IF qty_available > 0
            IF qty_available >= m.qty_to_cost
                * Повне закриття з поточної партії
                m.total_cost = m.total_cost + (m.qty_to_cost * unit_price)
                REPLACE qty_available WITH qty_available - m.qty_to_cost
                m.qty_to_cost = 0
            ELSE
                * Часткове закриття (партія закінчилась)
                m.total_cost = m.total_cost + (qty_available * unit_price)
                m.qty_to_cost = m.qty_to_cost - qty_available
                REPLACE qty_available WITH 0
            ENDIF
        ENDIF
    ENDSCAN

    * Прямий запис результатів назад у файли
    SELECT sales_lines
    REPLACE cogs WITH m.total_cost, processed WITH .T.

    SELECT inventory_items
    SEEK sales_lines.item_id
    IF FOUND()
        REPLACE total_qty WITH total_qty - sales_lines.qty_sold
    ENDIF

    SELECT sales_lines
ENDSCAN

CLOSE DATABASES
RETURN