(Spree::PermittedAttributes.class_variable_get("@@checkout_attributes") << [
  :bill_address_id, :ship_address_id
]).flatten!

Spree::Order.class_eval do
  before_validation :clone_shipping_address, :if => "Spree::AddressBook::Config[:disable_bill_address]"
  
  def clone_shipping_address
    if self.ship_address
      self.bill_address = self.ship_address
    end
    true
  end
  
  def clone_billing_address
    if self.bill_address
      self.ship_address = self.bill_address
    end
    true
  end
  
  def bill_address_id=(id)
    address = Spree::Address.where(:id => id).first
    if address && address.user_id == self.user_id
      self["bill_address_id"] = address.id
      self.user.update_attribute(:bill_address_id, address.id)
      self.bill_address.reload
    else
      self["bill_address_id"] = nil
    end
  end
  
  def bill_address_attributes=(attributes)
    self.bill_address = update_or_create_address(attributes)
    self.user.bill_address = self.bill_address if self.user
  end

  def ship_address_id=(id)
    address = Spree::Address.where(:id => id).first
    if address && address.user_id == self.user_id
      self["ship_address_id"] = address.id
      self.user.update_attribute(:ship_address_id, address.id)
      self.ship_address.reload
    else
      self["ship_address_id"] = nil
    end
  end
  
  def ship_address_attributes=(attributes)
    self.ship_address = update_or_create_address(attributes)
    self.user.ship_address = self.ship_address if self.user
  end

  def assign_default_addresses!
    if self.user
      self.bill_address = user.bill_address if !self.bill_address_id && user.bill_address.try(:valid?)
      # Skip setting ship address if order doesn't have a delivery checkout step
      # to avoid triggering validations on shipping address
      self.ship_address = user.ship_address if !self.ship_address_id && user.ship_address.try(:valid?) && self.checkout_steps.include?("delivery")
    end
  end
  
  #set_callback :updating_from_params, :before, :update_addresses_params

  private

  def update_addresses_params
    self.bill_address_attributes = @updating_params["order"].delete("bill_address_attributes")
    self.bill_address_id = @updating_params["order"].delete("bill_address_id")
    self.ship_address_attributes = @updating_params["order"].delete("ship_address_attributes")
    self.ship_address_id = @updating_params["order"].delete("ship_address_id")
  end
  
  def update_or_create_address(attributes = {})
    return if attributes.blank?
    attributes = attributes.select{|k,v| v.present?}.permit(permitted_address_attributes)

    if self.user
      address = self.user.addresses.build(attributes.except(:id)).check
      return address if address.id
    end

    if attributes[:id]
      address = Spree::Address.find(attributes[:id])
      attributes.delete(:id)

      if address && address.editable?
        address.update_attributes(attributes)
        return address
      else
        attributes.delete(:id)
      end
    end

    if !attributes[:id]
      address = Spree::Address.new(attributes)
      address.save
    end
    
    address
  end
  
  def permitted_address_attributes
    Spree::PermittedAttributes.class_variable_get("@@address_attributes")
  end
end
