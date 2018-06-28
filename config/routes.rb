Rails.application.routes.draw do
  devise_for :members
  root 'home#index'
  resources :graphics
  resources :users
  resources :shapes
  resources :colors
  resources :conversations do
  	member do
      post :close
    end
    resources :messages
  end
  resources :messages, only: [:create]
  resources :chats
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
