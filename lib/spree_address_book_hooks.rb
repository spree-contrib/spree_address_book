class SpreeAddressBookHooks < Spree::ThemeSupport::HookListener
  insert_after :account_my_orders, :partial => 'users/addresses'
end
