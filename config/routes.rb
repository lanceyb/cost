Rails.application.routes.draw do
  root to: "home#index"

  get 'result', to: 'home#result'

  devise_for :users

  resources :materials
  resources :users
  resources :composite_materials
end
