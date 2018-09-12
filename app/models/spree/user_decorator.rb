Spree.user_class.class_eval do
  has_many :addresses, -> { where(deleted_at: nil).order('updated_at DESC') }, class_name: Spree::Address
  belongs_to :ship_address, -> { where(deleted_at: nil) }, class_name: 'Spree::Address'
  belongs_to :bill_address, -> { where(deleted_at: nil) }, class_name: 'Spree::Address'
end
