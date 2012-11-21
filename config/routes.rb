Transitonrails::Application.routes.draw do

  devise_for :users do
    get 'login', :to => 'devise/sessions#new'
    get 'logout', :to => 'devise/sessions#destroy'
  end

  root :to => 'screens#index'

  resources :screens do
    member do
      #might need a route to check if asleep?
    end
    collection do
    end
  end

  resources :users, :only => [:edit, :update]
end
