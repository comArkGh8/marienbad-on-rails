Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  resources :board do
    collection do
      get :instructions
      get :human
      get :computer
      get :history
    end
  end

  # You can have the root of your site routed with "root"
  root 'board#index'

  #root :to => "board#index"


end
