Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  resources :users, only: %i[index show update]
  root to: 'posts#index'
  resources :health_check, only: [:index]
  resources :posts
  resources :post_drafts
  resources :mypages, only: :index
  get 'about', to: 'homes#index'
  resources    :posts do
    resources  :comments, only: %i[edit update create destroy]
  end
  resources :relationships, only: %i[create destroy]
  post   '/like/:post_id' => 'likes#like',   as: 'like'
  delete '/like/:post_id' => 'likes#unlike', as: 'unlike'
  post   '/comment_like/:comment_id' => 'comment_likes#comment_like',   as: 'comment_like'
  delete '/comment_like/:comment_id' => 'comment_likes#comment_unlike', as: 'comment_unlike'
  resources :notifications, only: :index
  post   '/favorite/:post_id' => 'favorites#favorite',   as: 'favorite'
  delete '/favorite/:post_id' => 'favorites#unfavorite', as: 'unfavorite'
  resources :favorites, only: %i[index]
end
