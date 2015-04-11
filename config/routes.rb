Rails.application.routes.draw do
  
  devise_for :admin, path_names: { sign_in: "sign-in" }
  
  resources :facts, only: [:show, :new, :create]

  namespace :admin do
    resources :facts, except: [:show, :new, :create]

    root to: "facts#index"
  end

  root to: "facts#show"

end
