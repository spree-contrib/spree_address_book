Spree::Core::Engine.routes.prepend do

  resources :addresses, :only => [:edit, :update, :destroy]

end
