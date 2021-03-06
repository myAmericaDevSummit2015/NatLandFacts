Rails.application.routes.draw do
  
  devise_for :admin, path_names: { sign_in: "sign-in" }
  
  resources :facts, only: [:show, :new, :create] do
    member do
      get :another
    end
  end
  
  resource :ridb, only: [], controller: 'ridb' do
    get :get_recreation_areas
    get :get_recreation_area
  end

  namespace :admin do
    resources :facts, except: [:show, :new, :create] do
      member do
        patch :validate
      end
    end

    root to: "facts#index"
  end

  root to: "facts#show"

end
