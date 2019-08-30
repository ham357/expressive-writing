Rails.application.routes.draw do
  devise_for :users
  resources :users, only: %i[index show]
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
end
