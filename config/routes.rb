Spree::Core::Engine.add_routes do
  namespace :admin do
    resources :orders do
      resources :addresses
    end
  end

  resources :addresses
end
