Spree::Core::Engine.add_routes do
  namespace :admin do
    resources :orders do
      resources :addresses, only: [:index, :create]
    end
  end

  resources :addresses
end
