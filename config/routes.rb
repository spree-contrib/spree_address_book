Spree::Core::Engine.routes.draw do
  resources :addresses #, :only => [:edit, :update, :destroy, :create]
end
