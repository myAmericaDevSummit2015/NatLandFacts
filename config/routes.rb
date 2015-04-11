Rails.application.routes.draw do
  
  devise_for :admins
  
  resources :facts, only: [:show, :new, :create]

  namespace :admin do
    resources :facts, except: [:show, :new, :create]

    root to: "facts#index"
  end

  root to: "facts#show"

end
