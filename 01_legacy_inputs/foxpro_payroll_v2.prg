* PAYROLL_LOGIC_1999.PRG
* Розрахунок податків: ПДФО(18%) та Військовий збір(1.5%)
PARAMETER nGrossSalary
IF nGrossSalary < 0
   RETURN 0
ENDIF
nIncomeTax = nGrossSalary * 0.18
nWarTax = nGrossSalary * 0.015
nNetSalary = nGrossSalary - nIncomeTax - nWarTax

* Прямий запис у застарілу таблицю
REPLACE salary_net WITH nNetSalary, calc_date WITH DATE()
RETURN nNetSalary