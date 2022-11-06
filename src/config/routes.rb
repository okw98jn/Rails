Rails.application.routes.draw do
  root to: 'home#top'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
  }
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#new_guest'
  end

  resources :users, only: [:show, :index] do
    resource :relationships, only: [:create, :destroy]
    get 'followings', to: 'relationships#followings', as: 'followings'
    get 'followers', to: 'relationships#followers', as: 'followers'
  end

  # 退会ページ
  get '/users/:id/unsubscribe', to: 'users#unsubscribe', as: 'unsubscribe'
  # 退会処理
  patch '/users/:id/withdrawal', to: 'users#withdrawal', as: 'withdrawal'

  resources :posts do
    resource :favorites, only: [:create, :destroy]
    resources :comments, only: [:edit, :update, :create, :destroy]
    collection do
      get 'search'
      get 'post_favorite_rank'
      get 'post_comment_rank'
    end
    member do
      get 'search_category'
    end
  end

  resources :notifications, only: [:index, :destroy]
end
