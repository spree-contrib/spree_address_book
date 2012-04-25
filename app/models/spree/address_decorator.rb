Spree::Address.class_eval do
  belongs_to :user

  def self.required_fields
    validator = Spree::Address.validators.find{|v| v.kind_of?(ActiveModel::Validations::PresenceValidator)}
    validator ? validator.attributes : []
  end
  
  # override same as to ignore new user_id. workaround for spec failure for bad controller filter.
  # TODO: look into if this is actually needed. I don't want to override methods unless it is really needed
  def same_as?(other)
    return false if other.nil?
    attributes.except('id', 'updated_at', 'created_at', 'user_id') ==  other.attributes.except('id', 'updated_at', 'created_at', 'user_id')
  end

  # can modify an address if it's not been used in an order
  def editable?
    new_record? || (shipments.empty? && (Spree::Order.where("bill_address_id = ?", self.id).count + Spree::Order.where("bill_address_id = ?", self.id).count <= 1) && Spree::Order.complete.where("bill_address_id = ? OR ship_address_id = ?", self.id, self.id).count == 0)
  end

  def can_be_deleted?
    shipments.empty? && Spree::Order.where("bill_address_id = ? OR ship_address_id = ?", self.id, self.id).count == 0
  end

  def to_s
    "#{firstname} #{lastname}<br/>#{address1} #{address2}<br/>#{city}, #{state || state_name} #{zipcode}<br/>#{country}".html_safe
  end

  # as of version 1.1 Spree::Address does not have a custom destroy method
  # if in the future it is added, this may cause issues
  def destroy
    if can_be_deleted?
      super
    else
      update_attribute(:deleted_at, Time.now)
    end
  end
end
