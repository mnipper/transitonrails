Transitonrails::Application.routes.draw do

  devise_for :users

  root :to => 'screens#index'

  resources :screens do
    member do
      #might need a route to check if asleep?
    end
    collection do
    end
  end
end
