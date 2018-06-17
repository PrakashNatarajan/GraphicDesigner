Rails.application.routes.draw do
  root 'home#dashboard'
  resources :graphics
  resources :users
  resources :shapes
  resources :colors
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
