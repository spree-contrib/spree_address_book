Deface::Override.new(
  :virtual_path => "users/show",
  :name => "address_book_account_my_orders",
  :insert_after => "[data-hook='account_my_orders'], #account_my_orders[data-hook]",
  :partial => "users/addresses",
  :disabled => false)
