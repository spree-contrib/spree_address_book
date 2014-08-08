Spree.user_class.class_eval do
  after_create :link_address

  has_many :addresses, -> { where(:deleted_at => nil).order("updated_at DESC") }, :class_name => 'Spree::Address'

  def link_address
    bill_address.update_attributes(user_id: id) if bill_address
    ship_address.update_attributes(user_id: id) if ship_address
  end
end
