Deface::Override.new(
  :virtual_path => 'spree/checkout/_address',
  :name => 'add_choose_existing_billing_address_form',
  :insert_before => '[data-hook="billing_inner"]',
  :partial => 'spree/checkout/choose_existing_billing',
  :original => 'b46e8f6f76c68f04c1379fe8f3f35f7d15f3d210',
)

Deface::Override.new(
  :virtual_path => 'spree/checkout/_address',
  :name => 'add_choose_existing_shipping_address_form',
  :surround => '[data-hook="shipping_inner"]',
  :partial => 'spree/checkout/choose_existing_shipping',
  :original => 'b93d6558ea591be5c78ccb7421611d9a02d9df4a',
)
