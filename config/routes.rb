Spree::Core::Engine.add_routes do
  resources :addresses
  resources :orders do
    member do
      get :addresses
    end
  end
end
