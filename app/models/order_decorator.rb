Order.class_eval do
  def clone_billing_address
    if bill_address and self.ship_address.nil?
      self.ship_address_id = bill_address.id
    end
    true
  end
  
  def bill_address_attributes=(attributes)
    self.bill_address = update_or_create_address(attributes)
  end
  
  def ship_address_attributes=(attributes)
    self.ship_address = update_or_create_address(attributes)
  end
  
  private
  
  def update_or_create_address(attributes)
    address = nil
    if attributes[:id]
      address = Address.find(attributes[:id])
      if address && address.editable?
        address.update_attributes(attributes)
      else
        attributes.delete(:id)
      end
    end
    
    if !attributes[:id]
      address = Address.new(attributes)
      address.save
    end
    
    address
  end
    
end
