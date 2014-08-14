Spree::Core::Engine.add_routes do
  namespace :admin do
    resources :orders do
      member do
        get :addresses
      end
    end
  end

  resources :addresses
end
