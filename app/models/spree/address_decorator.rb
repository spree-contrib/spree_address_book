(Spree::PermittedAttributes.class_variable_get("@@address_attributes") << [
  :user_id, :deleted_at
]).flatten!

Spree::Address.class_eval do
  belongs_to :user, class_name: Spree.user_class.name

  def self.required_fields
    Spree::Address.validators.map do |v|
      v.kind_of?(ActiveModel::Validations::PresenceValidator) ? v.attributes : []
    end.flatten
  end

  # TODO: look into if this is actually needed. I don't want to override methods unless it is really needed
  # can modify an address if it's not been used in an order
  def same_as?(other)
    return false if other.nil?
    attributes.except('id', 'updated_at', 'created_at', 'user_id') == other.attributes.except('id', 'updated_at', 'created_at', 'user_id')
  end

  # can modify an address if it's not been used in an completed order
  def editable?
    new_record? || (shipments.empty? && Spree::Order.complete.where("bill_address_id = ? OR ship_address_id = ?", self.id, self.id).count == 0)
  end

  def can_be_deleted?
    shipments.empty? && Spree::Order.where("bill_address_id = ? OR ship_address_id = ?", self.id, self.id).count == 0
  end

  def to_s
    [
      full_name,
      company,
      address1,
      address2,
      "#{city}, #{state_text} #{zipcode}",
      country.to_s
    ].reject(&:blank?).map{ |attribute| ERB::Util.html_escape(attribute) }.join('<br/>')
  end

  # UPGRADE_CHECK if future versions of spree have a custom destroy function, this will break
  def destroy
    if can_be_deleted?
      super
    else
      update_column :deleted_at, Time.now
    end
  end

  def check
    attrs = attributes.except('id', 'updated_at', 'created_at')
    the_same_address = user.addresses.where(attrs).first
    the_same_address ? the_same_address : self
  end
end
