Spree::Order.class_eval do
  attr_accessible :bill_address_id, :ship_address_id

  def bill_address_id=(id)
    address = Spree::Address.find_by_id(id)
    if address && address.user_id == self.user_id
      write_attribute :bill_address_id, address.id
      bill_address.reload.id
    else
      write_attribute :bill_address_id, nil
    end
  end

  def bill_address_attributes=(attributes)
    self.bill_address = update_or_create_address(attributes)
  end

  def ship_address_id=(id)
    address = Spree::Address.find_by_id(id)
    if address && address.user_id == self.user_id
      write_attribute :ship_address_id, address.id
      ship_address.reload.id
    else
      write_attribute :ship_address_id, nil
    end
  end

  def ship_address_attributes=(attributes)
    self.ship_address = update_or_create_address(attributes)
  end

  private

  def update_or_create_address(attributes)
    address = nil
    if attributes[:id]
      address = Spree::Address.find(attributes[:id])
      if address && address.editable?
        address.update_attributes(attributes)
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

end
