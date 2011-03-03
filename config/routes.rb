Rails.application.routes.draw do
  resources :addresses, :only => [:edit, :update, :destroy]
end
