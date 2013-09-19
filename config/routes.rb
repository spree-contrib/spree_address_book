Spree::Core::Engine.routes.prepend do
  resources :addresses, :except => :show do
    put :set_default_address, :on => :member
  end
end
