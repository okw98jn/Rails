Rails.application.routes.draw do
  root to: 'home#top'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#new_guest'
  end
  resources :users, only: [:show]
  # 退会ページ
  get '/users/:id/unsubscribe', to: 'users#unsubscribe', as: 'unsubscribe'
  # 退会処理
  patch '/users/:id/withdrawal', to: 'users#withdrawal', as: 'withdrawal'
end
