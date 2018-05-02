Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    resources :friends
  end

  root 'apipie/apipies#index'
  apipie
end
