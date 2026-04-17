procedure TWarehouse.UpdateStock(ItemID: Integer; Delta: Integer);
begin
  // Пряма маніпуляція даними всередині UI-компонента
  TableInventory.Locate('ID', ItemID, []);
  if TableInventory.FieldByName('Balance').AsInteger + Delta < 0 then
    raise Exception.Create('Недостатньо товару на складі!');

  TableInventory.Edit;
  TableInventory.FieldByName('Balance').AsInteger := 
    TableInventory.FieldByName('Balance').AsInteger + Delta;
  TableInventory.Post;
end;