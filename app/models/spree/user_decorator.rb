Spree::User.class_eval do
  has_many :addresses, :conditions => {:deleted_at => nil}, :order => "updated_at DESC"
end
