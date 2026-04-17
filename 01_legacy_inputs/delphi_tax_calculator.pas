unit TaxCalcForm;
interface
// ... UI components declaration ...

implementation

procedure TfrmInvoice.btnCalculateClick(Sender: TObject);
var
  SubTotal, TaxRate, FinalTax, Discount: Double;
begin
  // Extracting data from UI input fields (Bad practice)
  SubTotal := StrToFloat(txtSubTotal.Text);
  Discount := StrToFloat(txtDiscount.Text);
  
  if chkIsExport.Checked then
    TaxRate := 0.0 // Export is tax-free
  else
    TaxRate := 0.20; // Standard 20% VAT
    
  // Business Logic mixed with UI
  FinalTax := (SubTotal - Discount) * TaxRate;
  
  if FinalTax < 0 then FinalTax := 0;
  
  // Outputting back to UI
  lblTotalTax.Caption := FloatToStr(FinalTax);
  ShowMessage('Tax calculated successfully!');
end;