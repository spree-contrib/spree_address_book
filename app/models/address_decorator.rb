Address.class_eval do
  belongs_to :user
  before_update :check_address
  
  # can modify an address if it's not been used in an order 
  def editable?
    new_record? || (shipments.empty? && Order.complete.where("bill_address_id = ? OR ship_address_id = ?", self.id, self.id).count == 0)
  end
  
  def can_be_deleted?
    shipments.empty? && Order.where("bill_address_id = ? OR ship_address_id = ?", self.id, self.id).count == 0
  end
  
  def to_s
    "#{firstname} #{lastname}: #{address1} #{address2}"
  end
  
  private
  
  def check_address
    self.editable?
  end
end
