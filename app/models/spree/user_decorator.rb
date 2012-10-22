Spree.user_class.class_eval do
  has_many :addresses, :conditions => {:deleted_at => nil}, :order => "updated_at DESC", :class_name => 'Spree::Address'
end
