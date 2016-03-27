Spree::Core::Engine.add_routes do
  resources :addresses

  if Rails.env.test?
    put '/cart', :to => 'orders#update', :as => :put_cart
  end
end