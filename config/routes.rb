Rails.application.routes.draw do
  resources :health_check, only: [:index]
end
