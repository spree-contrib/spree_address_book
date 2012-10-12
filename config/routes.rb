Spree::Core::Engine.routes.prepend do
  resources :users do
    resources :addresses
  end
end
