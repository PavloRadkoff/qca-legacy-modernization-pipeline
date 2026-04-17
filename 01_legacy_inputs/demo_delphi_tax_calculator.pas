procedure TForm1.CalculateTaxClick(Sender: TObject);
begin
  // Hardcoded tax logic from 1999
  Total := StrToFloat(Edit1.Text) * 1.20;
end;
