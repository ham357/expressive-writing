Rails.application.routes.draw do
  devise_for :users
  root to: 'posts#index'
  resources :posts, only: %i[new create show edit destroy update]
  resources :mypages, only: :index
  get 'about', to: 'homes#index'
  resources    :posts do
    resources  :comments, only: %i[edit update create destroy]
  end
  post   '/like/:post_id' => 'likes#like',   as: 'like'
  delete '/like/:post_id' => 'likes#unlike', as: 'unlike'
end
