Rails.application.routes.draw do
  root to: 'top#index'
  resources :todos
  resources :health_check, only: [:index]
end
