* MODULE: FIXED ASSETS DEPRECIATION (1998)
SET EXCLUSIVE OFF
USE assets_db IN 0 SHARED

SELECT assets_db
SCAN FOR status = 'ACTIVE' AND cost > 0
    * Calculate 15% yearly depreciation
    LOCAL nDeprAmount
    nDeprAmount = cost * 0.15
    
    * Business rule: value cannot drop below salvage value (100)
    IF (current_val - nDeprAmount) < 100
        nDeprAmount = current_val - 100
    ENDIF
    
    REPLACE current_val WITH current_val - nDeprAmount
    REPLACE last_calc_date WITH DATE()
ENDSCAN
CLOSE DATABASES