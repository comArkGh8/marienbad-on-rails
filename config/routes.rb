Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  resources :game
  
  # You can have the root of your site routed with "root"
  root 'game#index'




end