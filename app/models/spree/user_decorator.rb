Spree.user_class.class_eval do
  has_many :addresses, -> { where(:deleted_at => nil).order("updated_at DESC") },
    :class_name => 'Spree::Address', inverse_of: :user
  accepts_nested_attributes_for :addresses
end
