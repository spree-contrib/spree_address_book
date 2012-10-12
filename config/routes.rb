Spree::Core::Engine.routes.prepend do
  namespace :account do
    resources :addresses, :only => [:new, :edit, :update, :destroy]
  end
end
