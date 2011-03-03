Order.class_eval do
  def clone_billing_address
    if bill_address and self.ship_address.nil?
      self.ship_address_id = bill_address.id
    end
    true
  end
end
