Deface::Override.new(
  :virtual_path => "spree/checkout/_address",
  :name => "add_choose_existing_billing_address_form",
  :insert_before => "[data-hook='billing_inner']",
  :partial => "spree/checkout/choose_existing_billing"
)

Deface::Override.new(
  :virtual_path => "spree/checkout/_address",
  :name => "add_choose_existing_shipping_address_form",
  :surround => "[data-hook='shipping_inner']",
  :partial => "spree/checkout/choose_existing_shipping"
)
